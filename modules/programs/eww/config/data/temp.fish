#!/usr/bin/env fish

set -l temp (sensors 2>/dev/null | awk '/Package id 0/ { print $4 }' | string sub -s 2 | string replace -r '\\..*' '')
if test -z "$temp"
    set temp (sensors | awk '/Tctl/ {print $2}' | tr -d '+°C')
end
if test -z "$temp"
    set temp --
end
echo "$temp"
