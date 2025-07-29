#!/usr/bin/env fish

function network-info
    nmcli -t -f SSID,SIGNAL,ACTIVE device wifi |
        grep 'yes$' |
        head -1 |
        cut -d':' -f 1,2 --output-delimiter \n -s |
        xargs printf '{ "ssid": "%s", "signal": "%s"}'\n
end

network-info

ip monitor link | while read line
    network-info
end
