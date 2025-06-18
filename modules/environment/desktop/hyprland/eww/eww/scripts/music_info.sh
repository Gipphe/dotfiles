#!/usr/bin/env bash

## Get data
STATUS="$(mpc status)"
COVER="/tmp/.music_cover.png"
MUSIC_DIR="$HOME/Music"

## Get status
if [[ $STATUS == *"[playing]"* ]]; then
  status="󰏤"
else
  status="󰐊"
fi

## Get song
song=$(mpc -f %title% current)
if [[ -z "$song" ]]; then
  song="Offline"
else
  song=$(echo "$song" | tr '"' '\\"')
fi

## Get artist
artist=$(mpc -f %artist% current)
if [[ -z "$artist" ]]; then
  artist=""
else
  artist=$(echo "$artist" | tr '"' '\\"')
fi

## Get time
time=$(mpc status | grep "%)" | awk '{print $4}' | tr -d '(%)')
if [[ -z "$time" ]]; then
  time="0"
fi

ctime=$(mpc status | grep "#" | awk '{print $3}' | sed 's|/.*||g')
if [[ -z "$ctime" ]]; then
  ctime="0:00"
fi

ttime=$(mpc -f %time% current)
if [[ -z "$ttime" ]]; then
  ttime="0:00"
fi

## Get cover
ffmpeg -i "${MUSIC_DIR}/$(mpc current -f %file%)" "${COVER}" -y &>/dev/null
STATUS=$?

# Check if the file has a embbeded album art
if [ "$STATUS" -eq 0 ]; then
  cover="$COVER"
else
  cover="images/music.png"
fi

cat <<EOF
{
  "song": "$song",
  "artist": "$artist",
  "status": "$status",
  "time": "$time",
  "ctime": "$ctime",
  "ttime": "$ttime",
  "cover": "$cover"
}
EOF

## Execute accordingly
# if [[ "$1" == "--song" ]]; then
#   get_song
# elif [[ "$1" == "--artist" ]]; then
#   get_artist
# elif [[ "$1" == "--status" ]]; then
#   get_status
# elif [[ "$1" == "--time" ]]; then
#   get_time
# elif [[ "$1" == "--ctime" ]]; then
#   get_ctime
# elif [[ "$1" == "--ttime" ]]; then
#   get_ttime
# elif [[ "$1" == "--cover" ]]; then
#   get_cover
# elif [[ "$1" == "--toggle" ]]; then
#   mpc -q toggle
# elif [[ "$1" == "--next" ]]; then
#   {
#     mpc -q next
#     get_cover
#   }
# elif [[ "$1" == "--prev" ]]; then
#   {
#     mpc -q prev
#     get_cover
#   }
# fi
