#!/usr/bin/env fish

set -l theme_file "$HOME/.cache/gipphe/theme"
set -l dir $(dirname -- "$(status filename)")

mkdir -p $(dirname -- $theme_file)
if test -e "$theme_file" && test "$(cat "$theme_file")" = dark
    cp -f "$dir/../colors/light.scss" "$dir/../colors/current.scss"
    echo light >"$theme_file"
else
    cp -f "$dir/../colors/dark.scss" "$dir/../colors/current.scss"
    echo dark >"$theme_file"
end
