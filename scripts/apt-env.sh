#!/usr/bin/env sh
# shellcheck disable=SC2034
set -a

DEBCONF_NONINTERACTIVE_SEEN=true
DEBIAN_FRONTEND=noninteractive
DEBIAN_PRIORITY=critical
TERM=linux
set +a

exec "$@"
