#!/usr/bin/env bash

# REMOTE="false"

source="$(cat shto.sh)"

printf "REMOTE: %s\n" "${REMOTE:-false}"

if [ "$REMOTE" == "true" ]; then
  source="$(curl -fsSL https://raw.githubusercontent.com/nasjp/shto.sh/main/shto.sh)"
fi

case_number=0

assert() {
  local input="$1"
  local expected="$2"
  case_number=$((case_number + 1))

  bash <(bash <(printf "%s" "$source") "$input")
  local actual="$?"

  if [ "$actual" = "$expected" ]; then
    printf "%03d) %s => %s\n" "$case_number" "$input" "$actual"
  else
    printf "%03d) %s => %s expected, but got %s\n" "$case_number" "$input" "$expected" "$actual"
    exit 1
  fi
}

printf "========================test========================\n"
assert '0' '0'
assert '4' '4'
assert '1+1' '2'
assert '1-1' '0'
assert '1 + 1 + 1' '3'
assert '1 + 1 + 1' '3'
assert '1 + 5 - 2' '4'
assert '18 * 5 / 2 - 1' '44'
assert '18 * 5 / (2 - 1)' '90'
assert '(18 * 5 / (2 - 1))' '90'
printf "========================test========================\n"
printf "OK\n"
