#!/usr/bin/env bash

calendar() {
  LOCK_FILE="$HOME/.cache/eww-calendar.lock"

  run() {
    ${EWW_CMD} open calendar
  }

  # Open widgets
  if [[ ! -f "$LOCK_FILE" ]]; then
    ${EWW_CMD} close system music_win audio_ctl
    touch "$LOCK_FILE"
    run && echo "ok good!"
  else
    ${EWW_CMD} close calendar
    rm "$LOCK_FILE" && echo "closed"
  fi
}

system() {
  LOCK_FILE_MEM="$HOME/.cache/eww-system.lock"

  run() {
    ${EWW_CMD} open system
  }

  # Open widgets
  if [[ ! -f "$LOCK_FILE_MEM" ]]; then
    ${EWW_CMD} close calendar music_win audio_ctl
    touch "$LOCK_FILE_MEM"
    run && echo "ok good!"
  else
    ${EWW_CMD} close system
    rm "$LOCK_FILE_MEM" && echo "closed"
  fi
}

music() {
  LOCK_FILE_SONG="$HOME/.cache/eww-song.lock"

  run() {
    ${EWW_CMD} open music_win
  }

  # Open widgets
  if [[ ! -f "$LOCK_FILE_SONG" ]]; then
    ${EWW_CMD} close system calendar
    touch "$LOCK_FILE_SONG"
    run && echo "ok good!"
  else
    ${EWW_CMD} close music_win
    rm "$LOCK_FILE_SONG" && echo "closed"
  fi
}

audio() {
  LOCK_FILE_AUDIO="$HOME/.cache/eww-audio.lock"

  run() {
    ${EWW_CMD} open audio_ctl
  }

  # Open widgets
  if [[ ! -f "$LOCK_FILE_AUDIO" ]]; then
    ${EWW_CMD} close system calendar music
    touch "$LOCK_FILE_AUDIO"
    run && echo "ok good!"
  else
    ${EWW_CMD} close audio_ctl
    rm "$LOCK_FILE_AUDIO" && echo "closed"
  fi
}

if [ "$1" = "calendar" ]; then
  calendar
elif [ "$1" = "system" ]; then
  system
elif [ "$1" = "music" ]; then
  music
elif [ "$1" = "audio" ]; then
  audio
fi
