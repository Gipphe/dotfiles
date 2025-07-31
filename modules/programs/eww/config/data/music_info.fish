#!/usr/bin/env fish

## Get data
set -l STATUS "$(mpc status)"
set -l COVER "/tmp/.music_cover.png"
set -l MUSIC_DIR "$HOME/Music"

## Get status
if string match -rq '\\[playing\\]' $STATUS
    status="󰏤"
else
    status="󰐊"
end

## Get song
set -l song "$(mpc -f '%title%' current)"
if test -z "$song"
    set song Offline
else
    set song "$(echo "$song" | tr '"' '\\"')"
end

## Get artist
set -l artist "$(mpc -f '%artist%' current)"
if test -z "$artist"
    set artist ""
else
    set artist "$(echo "$artist" | tr '"' '\\"')"
end

## Get time
set -l time "$(mpc status | grep "%)" | awk '{print $4}' | tr -d '(%)')"
if test -z "$time"
    set time 0
end

set -l ctime "$(mpc status | grep "#" | awk '{print $3}' | sed 's|/.*||g')"
if test -z "$ctime"
    set ctime "0:00"
end

set -l ttime "$(mpc -f %time% current)"
if test -z "$ttime"
    set ttime "0:00"
end

## Get cover
ffmpeg -i "$MUSIC_DIR/$(mpc current -f '%file%')" "$COVER" -y &>/dev/null
set -l STATUS $status
# Check if the file has a embbeded album art
if test "$STATUS" -eq 0
    set -l cover "$COVER"
else
    set -l cover "images/music.png"
end

jo song=$song artist=$artist status=$status time=$time ctime=$ctime ttime=$ttime cover=$cover
