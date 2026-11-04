use upload-cache.nu

export def --wrapped main [...args]: nothing -> nothing {
    let out_link = mktemp --dry
    nh os build --out-link $out_link

    let reply = if ($args | any { $in == "--ask" }) {
        print -e 'Apply the config?'
        input --default 'n' --numchar 1 '[y/n]'
    } else {
        'y'
    }
    match ($reply | str lowercase) {
        'y' => {
            upload-cache $out_link
            let nh_args = $args | where {$in != "--ask"}
            nh os ...($args)
        }
    }
}
