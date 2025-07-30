function info
    echo $argv >&2
end
function print-help
    info "Usage: record [options...]"
    info ""
    info "Options:"
    info "  -h, --help               Print this help."
    info "  -a, --area [<area>]      Record only part of screen. Format: x,y WxH."
    info "  -s, --screen <screen>    Select screen to record. Ignored if -a or --area is specified."
    info "  -o, --output <filepath>  Path to the saved video. Defaults to '~/Videos/<current date and time>.mp4'."
end
argparse --name record --exclusive 'a,s' h/help 'a/area=?' 's/screen=' 'o/output=' -- $argv
or return

if set -q _flag_help
    print-help
    exit
end

set -l opts

if set -q _flag_area
    set -l area "$_flag_area"
    if test -z "$area"
        set area "$(slurp)"
        test "$status" = 0 || exit 1
    end

    set -a opts --geometry "$area"
end

if not set -q _flag_area
    set -l selected_monitor $_flag_screen
    if test -z "$selected_monitor"
        set selected_monitor "$(slurp -p -o "%o")"
    end

    set -a opts --output "$selected_monitor"
end

set -gx dest "$_flag_output"
if test -z "$dest"
    set -l filename "$(date +'%F %R:%S').mp4"
    set dest "$HOME/Videos/$filename"
end
set -a opts -f "$dest"
mkdir -p "$(dirname -- "$dest")"
hyprctl keyword 'general:col.active_border' "rgb(ff0000)"

function final
    pkill wf-recorder
    hyprctl keyword 'general:col.active_border' "$window_border" &>/dev/null
    echo "Video saved to $dest"
end

trap final INT
wf-recorder $opts
