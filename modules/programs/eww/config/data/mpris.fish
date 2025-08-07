#!/usr/bin/env fish

# Players to _not_ follow for status.
set ignore_players Boots_Moon

set -l players (playerctl --list-all)
for i in (seq 1 (count players))
    if contains $players[$i] ignore_players
        set -e players[$i]
    end
end

playerctl metadata --follow --player="$(string join ',' $players)" --format '{
  "name": "{{playerName}}",
  "title": "{{title}}",
  "artist": "{{artist}}",
  "artUrl": "{{mpris:artUrl}}",
  "status": "{{status}}",
  "length_us": "{{mpris:length}}",
  "length_str": "{{duration(mpris:length)}}"
}' | jq -c '.'
