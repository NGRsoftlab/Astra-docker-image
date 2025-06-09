#!/usr/bin/env sh
set -ef

## Finds the last modification time of files passed to 'find'
find_fresh_ts() {
  {
    find "$@" -exec stat -c '%Y' '{}' '+' 2>/dev/null || :
    ## Guarantees that even if find finds nothing, it will return 1 (minimum time)
    echo 1
  } | sort -rn | head -n 1
}

## Checks whether package lists need
## to be updated (apt-get update) to
## avoid unnecessary queries to repositories
## saving time and traffic
_apt_update() {
  TS_SOURCES=$(find_fresh_ts /etc/apt/ -follow -regextype egrep -regex '.+\.(list|sources)$' -type f)
  TS_LISTS=$(find_fresh_ts /var/lib/apt/lists/ -maxdepth 1 -regextype egrep -regex '.+_Packages(\.(bz2|gz|lz[4o]|xz|zstd?))?$' -type f)
  if [ "${TS_SOURCES}" -gt "${TS_LISTS}" ]; then
    apt-env.sh apt-get update -qq
  fi
}

## Works around the '/var/lib/dpkg/available' file
## which older Debian/Ubuntu versions used to list available packages
_dpkg_avail_hack() {
  : "${DPKG_ADMINDIR:=/var/lib/dpkg}"
  VERSION_CODENAME=$(awk -F'=' '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release || echo 'unknown codename') || :
  FILE_DPKG_NAME="${DPKG_ADMINDIR}/available"
  case "${VERSION_CODENAME}" in
    ## For older systems if the available file is empty,
    ## calls '/usr/lib/dpkg/methods/apt/update' to fill it
    stretch | buster | bionic | focal | 1.7_x86-64)
      ## ref: https://unix.stackexchange.com/a/271387/49297
      if [ -s "${FILE_DPKG_NAME}" ]; then
        return
      fi
      /usr/lib/dpkg/methods/apt/update "${DPKG_ADMINDIR}" apt apt
      ;;
    *)
      touch "${FILE_DPKG_NAME}"
      ;;
  esac
}

_apt_update
_dpkg_avail_hack
## Replaces the current process with this command to avoid wasting extra memory
exec apt-env.sh apt-get install -y --no-install-recommends --no-install-suggests -qq "$@"
