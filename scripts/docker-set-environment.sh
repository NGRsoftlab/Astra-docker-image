#!/usr/bin/env bash

set -Eeuo pipefail

## Check receiving args on exists
: "${1:?}"
: "${2:?}"

docker_set_env() {
  local FULL_VERSION DOCKER_REVISION DOCKER_MAJOR_MINOR_PATCH_VERSION DOCKER_MAJOR_MINOR_VERSION

  ## Update cache
  apt-env.sh apt-get update -qq

  ## Search version on repository if received version is approximately
  FULL_VERSION=$(apt-cache show "${1}" \
    | grep -E '^Version:' \
    | sort -rV \
    | head -n1 \
    | awk '{print $2}' || echo '')

  ## Define variables for /etc/environment
  DOCKER_REVISION="${FULL_VERSION}"
  DOCKER_MAJOR_MINOR_PATCH_VERSION=$(docker --version | tr -d '[:alpha:],' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2,3)
  DOCKER_MAJOR_MINOR_VERSION=$(docker --version | tr -d '[:alpha:],' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2)

  ## Filling /etc/environment
  {
    echo "${2^^}_REVISION=${DOCKER_REVISION}"
    echo "${2^^}_BEGIN_BUILD_IN_EPOCH=$(date '+%s')"
    echo "${2^^}_MAJOR_MINOR_PATCH_VERSION=${DOCKER_MAJOR_MINOR_PATCH_VERSION}"
    echo "${2^^}_MAJOR_MINOR_VERSION=${DOCKER_MAJOR_MINOR_VERSION}"
  } >>/etc/environment
}

docker_set_env "${1}" "${2}"

exit 0
