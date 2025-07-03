#!/usr/bin/env fish

pamixer --get-volume-human | tr -d '%'

pactl subscribe | rg --line-buffered "on sink" | while read line
    pamixer --get-volume-human | tr -d '%'
end
