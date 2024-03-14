#!/usr/bin/env fish

function fish_right_prompt --description 'Write the right prompt'
    set_color --dim
    date '+%k:%M:%S'
    set_color normal
end
