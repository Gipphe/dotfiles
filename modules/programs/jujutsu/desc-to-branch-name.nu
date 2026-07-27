def main [--rev(-r): string]: nothing -> nothing {
    if $rev == null or $rev == "" {
        error make {msg: "Missing revision"}
    }

    let desc = jj show --template description --no-patch $rev | lines | first

    if $desc != "" and ($desc | str contains ':') {
        ($desc
          | str replace -r '\)?: ' '/'
          | str replace -ra '[^\w/]' '-'
          | str replace -ra "'\"`" ''
          | str lowercase
        )
    } else {
        # Fall back to "gipphe/push-<short_id>" if no description
        # is set, or description does not comply with
        # conventional commits.
        $"gipphe/push-(jj show --template short_id --no-patch $rev)"
    }
}
