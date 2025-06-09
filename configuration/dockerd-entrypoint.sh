#!/usr/bin/env bash

[[ ${DEBUG,,} != 'true' ]] || set -x

set -euo pipefail

## Check command on exist
__is_command() {
  command -v "${1}" >/dev/null
}

## Generate private key
__tls_ensure_private() {
  local FILE="$1"
  shift

  [[ -s ${FILE} ]] || openssl genrsa -out "${FILE}" 4096
}

## Setup SAN (Subject Alternative Names)
__tls_san() {
  {
    ip -oneline address | awk '{ gsub(/\/.+$/, "", $4); print "IP:" $4 }'
    {
      cat /etc/hostname
      echo 'docker'
      echo 'localhost'
      hostname -f
      hostname -s
    } | sed 's/^/DNS:/'
    [ -z "${DOCKER_TLS_SAN:-}" ] || echo "${DOCKER_TLS_SAN}"
  } | sort -u | xargs printf '%s,' | sed 's/,$//'
}

## Generate private certificate
__tls_generate_certs() {
  local DIR CERT_VALID_DAYS
  DIR="${1}"
  ## https://github.com/FiloSottile/mkcert/issues/174
  CERT_VALID_DAYS='825'

  shift

  ## If server/{ca,key,cert}.pem && !ca/key.pem, do NOTHING except verify (user likely managing CA themselves)
  ## If ca/key.pem || !ca/cert.pem, generate CA public if necessary
  ## If ca/key.pem, generate server public
  ## If ca/key.pem, generate client public
  ## (regenerating public certs every startup to account for SAN/IP changes and/or expiration)

  if [[ -s "${DIR}/server/ca.pem" && -s "${DIR}/server/cert.pem" && -s "${DIR}/server/key.pem" && ! -s "${DIR}/ca/key.pem" ]]; then
    openssl verify -CAfile "${DIR}/server/ca.pem" "${DIR}/server/cert.pem"
    return 0
  fi

  if [[ -s "${DIR}/ca/key.pem" || ! -s "${DIR}/ca/cert.pem" ]]; then
    ## If we either have a CA private key or do *not* have a CA public key, then we should create/manage the CA
    mkdir -p "${DIR}/ca"
    __tls_ensure_private "${DIR}/ca/key.pem"
    openssl req -new -key "${DIR}/ca/key.pem" \
      -out "${DIR}/ca/cert.pem" \
      -subj '/CN=docker:dind CA' -x509 -days "${CERT_VALID_DAYS}"
  fi

  if [[ -s "${DIR}/ca/key.pem" ]]; then
    ## If we have a CA private key, we should create/manage a server key
    mkdir -p "${DIR}/server"
    __tls_ensure_private "${DIR}/server/key.pem"
    openssl req -new -key "${DIR}/server/key.pem" \
      -out "${DIR}/server/csr.pem" \
      -subj '/CN=docker:dind server'
    cat >"${DIR}/server/openssl.cnf" <<-EOF
[ x509_exts ]
subjectAltName = $(__tls_san)
EOF
    openssl x509 -req \
      -in "${DIR}/server/csr.pem" \
      -CA "${DIR}/ca/cert.pem" \
      -CAkey "${DIR}/ca/key.pem" \
      -CAcreateserial \
      -out "${DIR}/server/cert.pem" \
      -days "${CERT_VALID_DAYS}" \
      -extfile "${DIR}/server/openssl.cnf" \
      -extensions x509_exts
    cp "${DIR}/ca/cert.pem" "${DIR}/server/ca.pem"
    openssl verify -CAfile "${DIR}/server/ca.pem" "${DIR}/server/cert.pem"
  fi

  if [[ -s "${DIR}/ca/key.pem" ]]; then
    ## If we have a CA private key, we should create/manage a client key
    mkdir -p "${DIR}/client"
    __tls_ensure_private "${DIR}/client/key.pem"
    chmod 0644 "${DIR}/client/key.pem" ## Openssl defaults to 0600 for the private key, but this one needs to be shared with arbitrary client contexts
    openssl req -new \
      -key "${DIR}/client/key.pem" \
      -out "${DIR}/client/csr.pem" \
      -subj '/CN=docker:dind client'
    cat >"${DIR}/client/openssl.cnf" <<-'EOF'
[ x509_exts ]
extendedKeyUsage = clientAuth
EOF
    openssl x509 -req \
      -in "${DIR}/client/csr.pem" \
      -CA "${DIR}/ca/cert.pem" \
      -CAkey "${DIR}/ca/key.pem" \
      -CAcreateserial \
      -out "${DIR}/client/cert.pem" \
      -days "${CERT_VALID_DAYS}" \
      -extfile "${DIR}/client/openssl.cnf" \
      -extensions x509_exts
    cp "${DIR}/ca/cert.pem" "${DIR}/client/ca.pem"
    openssl verify -CAfile "${DIR}/client/ca.pem" "${DIR}/client/cert.pem"
  fi
}

## Check can be loaded '/etc/environment' as default?
# shellcheck disable=SC2163
if [[ -f /etc/environment ]]; then
  while IFS= read -r line; do
    [ -z "${line}" ] && continue
    case "${line}" in
      \#*) continue ;;
      *) export "${line}" ;;
    esac
  done </etc/environment
fi

## Check, can preview '/etc/issue'?
if [[ -s /etc/issue ]] && [[ ! -t 0 ]]; then
  cat /etc/issue
fi

## First arg is `-f` or `--some-option`
if [[ $# -eq 0 || ${1#-} != "${1}" ]]; then
  ## Set "DOCKER_SOCKET" to the default "--host" *unix socket* value (for both standard or rootless)
  CURRENT_UID="$(id -u)"
  if [[ ${CURRENT_UID} -eq 0 ]]; then
    DOCKER_SOCKET='unix:///var/run/docker.sock'
  else
    ## If we're not root, we must be trying to run rootless
    : "${XDG_RUNTIME_DIR:=/run/user/${CURRENT_UID}}"
    DOCKER_SOCKET="unix://${XDG_RUNTIME_DIR}/docker.sock"
  fi

  case "${DOCKER_HOST:-}" in
    unix://*)
      DOCKER_SOCKET="${DOCKER_HOST}"
      ;;
  esac

  ## Add our default arguments
  if [[ -n ${DOCKER_TLS_CERTDIR:-} ]]; then
    __tls_generate_certs "${DOCKER_TLS_CERTDIR}"
    ## Generate certs and use TLS if requested/possible (default in 19.03+)
    set -- dockerd \
      --host="${DOCKER_SOCKET}" \
      --host=tcp://0.0.0.0:2376 \
      --tlsverify \
      --tlscacert "${DOCKER_TLS_CERTDIR}/server/ca.pem" \
      --tlscert "${DOCKER_TLS_CERTDIR}/server/cert.pem" \
      --tlskey "${DOCKER_TLS_CERTDIR}/server/key.pem" \
      "$@"
    DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="${DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS:-} -p 0.0.0.0:2376:2376/tcp"
  else
    ## TLS disabled (-e DOCKER_TLS_CERTDIR='') or missing certs
    set -- dockerd \
      --host="${DOCKER_SOCKET}" \
      --host=tcp://0.0.0.0:2375 \
      "$@"
    DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="${DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS:-} -p 0.0.0.0:2375:2375/tcp"
  fi
else
  ## If our command is a valid Docker subcommand, let's invoke it through Docker instead
  ## (this allows for "docker run docker ps", etc)
  if docker help "${1}" >/dev/null 2>&1; then
    set -- docker "$@"
  fi
fi

if [[ ${1} == 'dockerd' ]]; then
  ## Explicitly remove Docker's default PID file to ensure that it can start properly if it was stopped uncleanly (and thus didn't clean up the PID file)
  find /run /var/run -iname 'docker*.pid' -delete || :

  ## XXX inject "docker-init" (tini) as pid1 to workaround
  ## https://github.com/docker-library/docker/issues/318 (zombie container-shim processes)
  set -- docker-init -- "$@"

  ## So users can see whether it's legacy or not
  iptables --version

  CURRENT_UID="$(id -u)"
  if [[ ${CURRENT_UID} -ne 0 ]]; then
    ## If we're not root, we must be trying to run rootless
    if ! __is_command rootlesskit; then
      echo >&2 "[ERROR]: attempting to run rootless dockerd but missing 'rootlesskit' (perhaps the 'docker:dind-rootless' image variant is intended?)"
      exit 1
    fi

    USER="$(id -un 2>/dev/null || :)"
    if ! grep -qE "^(${CURRENT_UID}${USER:+|$USER}):" /etc/subuid || ! grep -qE "^(${CURRENT_UID}${USER:+|$USER}):" /etc/subgid; then
      echo >&2 "[ERROR]: attempting to run rootless dockerd but missing necessary entries in /etc/subuid and/or /etc/subgid for ${CURRENT_UID}"
      exit 1
    fi

    : "${XDG_RUNTIME_DIR:=/run/user/${CURRENT_UID}}"
    export XDG_RUNTIME_DIR

    if ! mkdir -p "${XDG_RUNTIME_DIR}" || [[ ! -w ${XDG_RUNTIME_DIR} ]] || ! mkdir -p "${HOME}/.local/share/docker" || [[ ! -w ${HOME}/.local/share/docker ]]; then
      echo >&2 "[ERROR]: attempting to run rootless dockerd but need writable HOME ($HOME) and XDG_RUNTIME_DIR ($XDG_RUNTIME_DIR) for user ${CURRENT_UID}"
      exit 1
    fi

    if [[ -f /proc/sys/kernel/unprivileged_userns_clone ]] && UNPRIV_CLONE="$(</proc/sys/kernel/unprivileged_userns_clone)" && [[ ${UNPRIV_CLONE} -ne 1 ]]; then
      echo >&2 "[ERROR]: attempting to run rootless dockerd but need 'kernel.unprivileged_userns_clone' (/proc/sys/kernel/unprivileged_userns_clone) set to 1"
      exit 1
    fi

    if [[ -f /proc/sys/user/max_user_namespaces ]] && MAX_USER_NS="$(</proc/sys/user/max_user_namespaces)" && [[ ${MAX_USER_NS} -eq 0 ]]; then
      echo >&2 "[ERROR]: attempting to run rootless dockerd but need 'user.max_user_namespaces' (/proc/sys/user/max_user_namespaces) set to a sufficiently large value"
      exit 1
    fi

    export TINI_SUBREAPER=1
    # shellcheck disable=SC2086
    exec tini -- \
      rootlesskit \
      --net="${DOCKERD_ROOTLESS_ROOTLESSKIT_NET:-slirp4netns}" \
      --mtu="${DOCKERD_ROOTLESS_ROOTLESSKIT_MTU:-65520}" \
      --disable-host-loopback \
      --port-driver=slirp4netns \
      --copy-up=/etc \
      --copy-up=/run \
      ${DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS:-} \
      "$@"

  elif [ -x '/usr/local/bin/dind' ]; then
    ## If we have the (mostly defunct now) Docker-in-Docker wrapper script, use it
    set -- '/usr/local/bin/dind' "$@"
  fi
else
  ## If it isn't `dockerd` we're trying to run, pass it through `docker-entrypoint.sh` so it gets `DOCKER_HOST` set appropriately too
  set -- docker-entrypoint.sh "$@"
fi

exec "$@"
