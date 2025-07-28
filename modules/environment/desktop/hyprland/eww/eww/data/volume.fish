#!/usr/bin/env fish

pamixer --get-volume

pactl subscribe | rg --line-buffered "on sink" | while read line
    pamixer --get-volume
end
