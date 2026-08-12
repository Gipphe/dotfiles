def main [
    --area(-a): string # Record only part of screen. Format: x,y WxH.
    --screen(-s): string # Select screen to record. Ignored if -a or --area is specified.
    --output(-o): path # Path to the saved video. Defaults to '~/Videos/<current date and time>.mp4'.
]: nothing -> nothing {
    let area = if $screen != null and $screen != "" {
        [--output, $screen]
    } else if $area != null and $area != "" {
        [--geometry, $area]
    } else {
        let a = (slurp)
        [--geometry, $a]
    }

    let dest = if $output != null and $output != "" {
        $output
    } else {
        $"(date now | format date '%F %R:%S').mp4" | $"($env.HOME)/Videos/($in)"
    }
    $dest | path dirname | mkdir $in

    let opts = [...$area, '-f', $dest]

    hyprctl eval "hl.config { general = {['col.active_border'] = 'rgb(ff0000)'}}"

    let recorder_id = job spawn { 
        wf-recorder ...$opts
    }
    print "Press any key to stop the recording..."
    input listen --types [key]
    job kill $recorder_id
    hyprctl reload
    print $"Video saved to ($dest)"
}
