#!/usr/bin/env sh

set -ef

apt purge -y --allow-remove-essential "$@"

## Replaces the current process with this command to avoid wasting extra memory
exec apt autopurge -y
