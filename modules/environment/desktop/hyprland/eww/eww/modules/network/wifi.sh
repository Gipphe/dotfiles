#!/usr/bin/env bash

res=$(
  nmcli -t -f SSID,SIGNAL,ACTIVE device wifi |
    grep 'yes$' |
    head -1 |
    cut -d':' -f 1,2 --output-delimiter $'\n' -s |
    xargs printf '{ "ssid": "%s", "signal": "%s"}'
)

if test -z "$res"; then
  echo '{"ssid": "", signal: 0}'
else
  echo "$res"
fi
