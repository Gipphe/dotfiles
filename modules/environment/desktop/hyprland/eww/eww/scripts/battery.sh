#!/usr/bin/env bash

bat() {
  fd -1 'BAT' /sys/class/power_supply/
}

printf '{"capacity": %s, "status": "%s"}' "$(cat "$(bat)/capacity")" "$(cat "$(bat)/status")"
