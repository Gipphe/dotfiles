def desc-to-branch-name [--rev(-r): string]: nothing -> string {
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
          | str replace -ar '[^/:\w\d]' '-'
          | str replace -ar ':+' '/'
          | prepend "gipphe/"
          | str join
          | str trim --char '-'
        )
    } else {
        $"gipphe/push-(jj show --template short_id --no-patch $rev)"
    }
}

def main [--revision(-r): string]: nothing -> nothing {
    let rev = $revision | default '@'
    let desc = desc-to-branch-name -r $rev

    jj bookmark create -r $rev $desc
    jj bookmark track --remote origin $desc
    jj git push --bookmark $desc
}
