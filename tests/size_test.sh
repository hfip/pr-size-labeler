#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../scripts/size.sh"

failures=0

expect() {
  local total="$1" want="$2" actual
  actual=$(size_label "${total}")
  if [ "${actual}" != "${want}" ]; then
    echo "FAIL size_label(${total}) = ${actual}, want ${want}"
    failures=$(( failures + 1 ))
  fi
}

expect 0 xs
expect 9 xs
expect 10 s
expect 99 s
expect 100 m
expect 499 m
expect 500 l
expect 999 l
expect 1000 xl
expect 20000 xl

# Thresholds are configurable through the environment.
export SIZE_XS_MAX=5 SIZE_S_MAX=20 SIZE_M_MAX=50 SIZE_L_MAX=100
expect 4 xs
expect 5 s
expect 20 m
expect 50 l
expect 100 xl
unset SIZE_XS_MAX SIZE_S_MAX SIZE_M_MAX SIZE_L_MAX

if [ "$(size_color xs)" != "0e8a16" ]; then
  echo "FAIL color map"
  failures=$(( failures + 1 ))
fi

if [ "${failures}" -ne 0 ]; then
  echo "${failures} failure(s)"
  exit 1
fi

echo "all size checks passed"
