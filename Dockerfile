## Definite image args
ARG image_registry
ARG image_name=astra
ARG image_version=1.8.2-slim

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                         Base image                          #
#               First stage, prepare environment              #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM ${image_registry}${image_name}:${image_version} AS base-stage

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ARG dind_additional_tools='curl sshpass jq xmlstarlet yq'

## ENV for build args
ENV \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=linux \
    TZ=Etc/UTC

## Copy issue
COPY docs/issue /etc/issue

## Pre-add a "docker" group for socket usage
RUN groupadd --system docker --gid 2375

## Install docker rootless mode and adapt for dind
## Always use the latest version available for the current DEB distribution
RUN \
    --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
    apt-install.sh \
## Dind tools
        docker.io \
        docker-buildx \
        docker-compose-v2 \
## Dockerd tools
        ca-certificates \
        ## DOCKER_HOST=ssh://... -- https://github.com/docker/cli/pull/1014
        openssh-client \
        ## https://github.com/docker-library/docker/issues/482#issuecomment-2197116408
        git \
## Additional tools
        ${dind_additional_tools} \
## Set environment
    && docker-set-environment.sh "docker.io" "docker_cli" \
## Generate machine id to prevent error:
## Failed to determine machine id:
## %v failed to get machine ID, '/etc/machine-id' is empty
    && echo "$(</proc/sys/kernel/random/uuid)" >/etc/machine-id \
## Remove cache
    && apt-clean.sh \
## Smoke test
    && docker --version \
    && docker buildx version \
    && docker-compose --version \
    && docker compose version

## Ensure that nsswitch.conf is set up for Go's "netgo" implementation (which Docker explicitly uses)
## - https://github.com/moby/moby/blob/v24.0.6/hack/make.sh#L111
## - https://github.com/golang/go/blob/go1.19.13/src/net/conf.go#L227-L303
## - docker run --rm debian:stretch grep '^hosts:' /etc/nsswitch.conf
RUN [[ -e /etc/nsswitch.conf ]] && grep -E '^hosts:.*files dns' /etc/nsswitch.conf

## Prune unused files
RUN \
    find /tmp/ ! -type d -ls -delete \
    && { \
        find /run/ -mindepth 1 -ls -delete || :; \
    } \
## Ensure '.exe' extension is not exits
    && find "/usr/" -iname '*.exe' -ls -delete \
    && install -d -m 01777 /run/lock \
## Check can be preview /etc/issue
    && { \
        grep -qF 'cat /etc/issue' /etc/bash.bashrc \
        || echo 'cat /etc/issue' >> /etc/bash.bashrc; \
    }

COPY configuration/dockerd-entrypoint.sh /usr/local/bin/
COPY configuration/dind.sh /usr/local/bin/
COPY configuration/docker-entrypoint-cli.sh /usr/local/bin/docker-entrypoint.sh
COPY configuration/modprobe.sh /usr/local/bin/modprobe

## Also, ensure the directory pre-exists and has wide enough permissions for "dockerd-entrypoint.sh" to create subdirectories, even when run in "rootless" mode
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client
## (doing both /certs and /certs/client so that if Docker does a "copy-up" into a volume defined on /certs/client, it will "do the right thing" by default in a way that still works for rootless users)

## Deduplication clean
RUN --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly dedup-clean.sh /usr/

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                        Final image                          #
#             Second stage, compact optimize layer            #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM scratch

COPY --from=base-stage / /

## Set base label
LABEL \
    maintainer="Vladislav Avdeev" \
    organization="NGRSoftlab"

## Set environment
ENV \
    LANG='en_US.UTF8' \
    LC_ALL='en_US.UTF8' \
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    TERM='xterm-256color' \
    TZ=Etc/UTC \
    DEBIAN_FRONTEND='noninteractive'

## https://github.com/docker-library/docker/pull/166
##   dockerd-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-generating TLS certificates
##   docker-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-setting DOCKER_TLS_VERIFY and DOCKER_CERT_PATH
## (For this to work, at least the "client" subdirectory of this path needs to be shared between the client and server containers via a volume, "docker cp", or other means of data sharing.)
ENV DOCKER_TLS_CERTDIR=/certs

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
