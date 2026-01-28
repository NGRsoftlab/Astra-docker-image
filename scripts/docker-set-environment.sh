#!/usr/bin/env bash

set -Eeuo pipefail

## Check receiving args on exists
: "${1:?}"
: "${2:?}"

docker_set_env() {
  local full_version docker_revision docker_major_minor_patch_version docker_major_minor_version

  ## Update cache
  apt-env.sh apt-get update -qq

  ## Search version on repository if received version is approximately
  full_version=$(apt-cache show "${1}" \
    | grep -E '^Version:' \
    | sort -rV \
    | head -n1 \
    | awk '{print $2}' || echo '')

  ## Define variables for /etc/environment
  docker_revision="${full_version}"
  docker_major_minor_patch_version=$(docker --version | tr -d '[:alpha:],' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2,3)
  docker_major_minor_version=$(docker --version | tr -d '[:alpha:],' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2)

  ## Filling /etc/environment
  {
    echo "${2^^}_REVISION=${docker_revision}"
    echo "${2^^}_BEGIN_BUILD_IN_EPOCH=$(date '+%s')"
    echo "${2^^}_MAJOR_MINOR_PATCH_VERSION=${docker_major_minor_patch_version}"
    echo "${2^^}_MAJOR_MINOR_VERSION=${docker_major_minor_version}"
  } >>/etc/environment
}

docker_set_env "${1}" "${2}"

exit 0
