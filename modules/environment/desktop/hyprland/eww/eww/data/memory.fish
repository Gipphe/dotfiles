#!/usr/bin/env fish

set -l total (awk '/MemTotal:/ { print $2 }' /proc/meminfo)
set -l available (awk '/MemAvailable:/ { print $2 }' /proc/meminfo)
jo \
    total="$total" \
    available="$available" \
    used="$(math $total - $available)" \
    percent="$(math \( $total - $available \) / $total x 100 )"
