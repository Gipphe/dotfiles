#!/usr/bin/env fish

playerctl metadata --format '{
  "name": "{{playerName}}",
  "title": "{{title}}",
  "artist": "{{artist}}",
  "artUrl": "{{mpris:artUrl}}",
  "status": "{{status}}",
  "length_us": "{{mpris:length}}",
  "length_str": "{{duration(mpris:length)}}"
}' | jq -c '.'
