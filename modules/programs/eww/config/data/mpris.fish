#!/usr/bin/env fish

# Players to _not_ follow for status.
set ignore_players Boots_Moon

set -l players (playerctl --list-all)
for i in (seq 1 (count players))
    if contains $players[$i] ignore_players
        set -e players[$i]
    end
end
set -a players spotify

begin
    set -l res
    for x in $players
        if ! contains $x $res
            set -a res $x
        end
    end
    set players $res
end

set -l format '{{playerName}};;;{{title}};;;{{artist}};;;{{mpris:artUrl}};;;{{status}};;;{{mpris:length}};;;{{duration(mpris:length)}}'

playerctl --follow --player=(string join ',' $players) --format "$format" metadata | while read line
    set -l parts $(echo "$line" | sed 's/;;;/\n/g')
    jo \
        playerName="$parts[1]" \
        title="$parts[2]" \
        artist="$parts[3]" \
        artUrl="$parts[4]" \
        status="$parts[5]" \
        length_us="$parts[6]" \
        length_str="$parts[7]"
end
