#!/usr/bin/env sh

set -efx

## Check command on exist
__is_command() {
  command -v "${1}" >/dev/null
}

## Check receiving args on exists
: "${1:?}"

## Ensure 'jdupes' exists
__is_command jdupes || apt-install.sh jdupes

## Calculate space before 'jdupes' use
echo
du -xd1 "${1}" | sort -Vk2
echo

## Prune deduplicate
jdupes -1LSpr "${1}"

## Calculate space before 'jdupes' use
echo
du -xd1 "${1}" | sort -Vk2
echo

## Prune 'jdupes' if exists
if __is_command jdupes; then
  apt-env.sh apt-remove.sh jdupes
  apt-clean.sh
fi

## Regenerate man1-9 directories
if [ ! -d /usr/share/man/man1 ]; then
  for i in $(seq 1 9); do
    mkdir -p /usr/share/man/man"${i}"
  done
fi

exit 0
