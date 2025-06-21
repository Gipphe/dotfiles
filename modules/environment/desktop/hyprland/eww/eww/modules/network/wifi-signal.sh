#!/usr/bin/env bash

res=$(
  nmcli -t -f SIGNAL,ACTIVE device wifi |
    grep 'yes$' |
    head -1 |
    cut -d':' -f 1 -s
)

if test -z "$res"; then
  echo "0"
else
  echo "$res"
fi
