#!/usr/bin/env bash

wifi=$(nmcli -t -f DEVICE,TYPE device status | grep 'wifi$' | cut -d: -f1)
ssid=$(nmcli -t -f SSID,ACTIVE device wifi | grep 'yes$' | cut -d: -f1)
connected=

# Emit current SSID first
nmcli -t -f SSID,ACTIVE device wifi |
  grep 'yes$' |
  head -1 |
  cut -d':' -f 1 -s

# Monitor for SSID changes
nmcli device monitor "$wifi" | while read -r line; do
  case "$line" in
  "$wifi: using connection"*)
    ssid=$(echo "$line" | sed -n "s/.*using connection '\([^']*\)'.*/\1/p")
    ;;
  "$wifi: disconnected"*)
    ssid=
    connected=
    ;;
  "$wifi: connected"*)
    connected=1
    ;;
  *)
    # Unknown line from monitor
    continue
    ;;
  esac

  if test -n "$connected"; then
    echo "$ssid"
  else
    echo ''
  fi
done
