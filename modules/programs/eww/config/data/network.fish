#!/usr/bin/env fish

function network-info
    set -l wifi (
        nmcli -t -f SSID,SIGNAL,ACTIVE device wifi |
            grep 'yes$' |
            head -1 |
            cut -d':' -f 1,2 --output-delimiter \n -s |
            xargs printf '{ "ssid": "%s", "signal": "%s"}'\n
    )
    set -l wired (
        nmcli -g TYPE,STATE device status | grep -q '^ethernet:connected' &&
        echo true ||
        echo false
    )
    jo wifi="$wifi" wired="$wired"
end

network-info

ip monitor link | while read line
    network-info
end
