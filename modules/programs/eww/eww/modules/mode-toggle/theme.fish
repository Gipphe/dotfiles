#!/usr/bin/env fish

set -l theme_file "$HOME/.cache/gipphe/theme"
set -l dir $(dirname -- "$(status filename)")
set -l color_dir "$dir/../../colors"

mkdir -p $(dirname -- $theme_file)
if test -e "$theme_file" && test "$(cat "$theme_file")" = dark
    cp -f "$color_dir/light.scss" "$color_dir/current.scss"
    echo light >"$theme_file"
else
    cp -f "$color_dir/dark.scss" "$color_dir/current.scss"
    echo dark >"$theme_file"
end
