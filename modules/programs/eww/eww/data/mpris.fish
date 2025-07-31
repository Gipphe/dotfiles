#!/usr/bin/env fish

playerctl metadata -F -f '{
  "name": "{{playerName}}",
  "title": "{{title}}",
  "artist": "{{artist}}",
  "artUrl": "{{mpris:artUrl}}",
  "status": "{{status}}",
  "length": "{{mpris:length}}",
  "lengthStr": "{{duration(mpris:length)}}"
}' | while read line
    set -l length (echo $line | jq --raw '.length')
    if test -n "$length"
        set length (math $length '/' 1000000)
        set length (math floor '(' $length + 0.5 ')' )
    end
    echo "$line" | jq -c --arg length "$length" '. + {length: "'$length'"}'
end
