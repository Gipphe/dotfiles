#!/usr/bin/env nu

def --wrapped main [unit: string, out_link: string, ...rest]: nothing -> nothing {
    let res = ^cachix push gipphe $out_link ...($rest) | complete
    print $res.stdout
    print --stderr $res.stderr
    if $res.exit_code != 0 {
        (
            ^notify-send
                --urgency critical
                --app-name upload-cache
                $"upload-cache failed\n"
                $"See: journalctl --user -u ($unit)\n\n($res.stderr | str trim)"
        )
        exit $res.exit_code
    }
}
