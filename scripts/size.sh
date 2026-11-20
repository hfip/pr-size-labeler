#!/usr/bin/env bash
# Shared size rules. Source this file; do not execute it.

size_label() {
  local total="${1:-0}"
  local small="${SIZE_XS_MAX:-10}"
  local medium="${SIZE_S_MAX:-100}"
  local large="${SIZE_M_MAX:-500}"
  local huge="${SIZE_L_MAX:-1000}"

  if (( total < small )); then
    echo "xs"
  elif (( total < medium )); then
    echo "s"
  elif (( total < large )); then
    echo "m"
  elif (( total < huge )); then
    echo "l"
  else
    echo "xl"
  fi
}

size_color() {
  case "${1:-xs}" in
    xs) echo "0e8a16" ;;
    s) echo "1d76db" ;;
    m) echo "fbca04" ;;
    l) echo "d93f0b" ;;
    *) echo "b60205" ;;
  esac
}

size_description() {
  case "${1:-xs}" in
    xs) echo "tiny: under 10 changed lines" ;;
    s) echo "small: under 100 changed lines" ;;
    m) echo "medium: under 500 changed lines" ;;
    l) echo "large: under 1000 changed lines" ;;
    *) echo "extra large: 1000+ changed lines, consider splitting" ;;
  esac
}
