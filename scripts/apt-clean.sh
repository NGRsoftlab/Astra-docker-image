#!/usr/bin/env sh

set -f

## APT
find /var/cache/apt/ ! -type d ! -name 'lock' -delete
find /var/lib/apt/ ! -type d -wholename '/var/lib/apt/listchanges*' -delete
find /var/lib/apt/lists/ ! -type d ! -name 'lock' -delete
find /var/log/ ! -type d -wholename '/var/log/apt/*' -delete
find /var/log/ ! -type d -wholename '/var/log/aptitude*' -delete
find /var/tmp/ ! -type d -ls -delete

## DPKG
: "${DPKG_ADMINDIR:=/var/lib/dpkg}"
truncate -s 0 "${DPKG_ADMINDIR}/available"
find "${DPKG_ADMINDIR}/" ! -type d -wholename "${DPKG_ADMINDIR}/*-old" -delete
find /var/log/ ! -type d -wholename '/var/log/alternatives.log' -delete
find /var/log/ ! -type d -wholename '/var/log/dpkg.log' -delete

## Not recommended run it at host
find "${DPKG_ADMINDIR}/" ! -type d -wholename "${DPKG_ADMINDIR}/info/*.symbols" -delete

## Debconf
find /var/cache/debconf/ ! -type d -wholename '/var/cache/debconf/*-old' -delete

## Check command on exist
__is_command() {
  command -v "${1}" >/dev/null
}

## Rationality to use 'gawk'
## 'mawk' - not stable work with UTF-8 (Unicode)
__debconf_trim_i18n() {
  gawk 'BEGIN { m = 0 }
      $0 == "" { print }
      /^[^[:space:]]/ {
          if ($1 ~ "\\.[Uu][Tt][Ff]-?8:") { m = 1; next; }
          m = 0; print $0;
      }
      /^[[:space:]]/ {
          if (m == 1) next;
          print $0;
      }' <"${1}" >"${__temporary}"
  cat <"${__temporary}" >"${1}"
}

if __is_command gawk; then
  __temporary=$(mktemp)
  : "${__temporary:?}"

  ## If broken, such as
  ## Use of uninitialized value $item in hash element at /usr/share/perl5/Debconf/DbDriver/File.pm line 85, <__ANONIO__> chunk 1.
  ## Use:
  ## dpkg-reconfigure debconf
  ## dpkg --configure -a
  ## rm /var/cache/debconf/*.dat
  ## dpkg-reconfigure debconf
  if [ -f /var/cache/debconf/templates.dat ]; then
    __debconf_trim_i18n /var/cache/debconf/templates.dat
  fi

  while read -r tmpl; do
    [ -n "${tmpl}" ] || continue
    [ -s "${tmpl}" ] || continue
    __debconf_trim_i18n "${tmpl}"
  done <<EOF
$(find "${DPKG_ADMINDIR}/info/" -type f -name '*.templates' | sort -V)
EOF
  rm -f "${__temporary}"
  unset __temporary
fi

## Miscellaneous
rm -f /var/cache/ldconfig/aux-cache

exit 0
