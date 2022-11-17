#!/bin/sh
#shellcheck disable=SC2004,SC2016

assert() {
  input="$1"
  expected="$2"

  ./s4h.sh "$input" >tmp.sh
  chmod +x tmp.sh
  ./tmp.sh >tmp.out
  actual=$(cat tmp.out)

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

assert '0' '0'
assert '4' '4'
assert '1+1' '2'
assert '1-1' '0'
assert '1 + 1 + 1' '3'
assert '1 + 1 + 1' '3'
assert '1 + 5 - 2' '4'
echo "OK"
