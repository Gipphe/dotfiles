def get-description []: string -> string {
    jj show --template description --no-patch $in | lines | first
}

def desc-to-bookmark []: string -> string {
    let desc = $in
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
        null
    }
}

def get-fallback-bookmark []: string -> string {
    $"gipphe/push-(jj show --template 'change_id.shortest(8)' --no-patch $in)"
}

# Create a bookmark for a revision based on that revision's description. Falls
# back to the revision's change ID if no bookmark could be created from the
# description.
def main [revision: string]: nothing -> string {
    let rev = $revision | default '@'
    let bookmark = (
      $rev
        | get-description
        | desc-to-bookmark
        | default ($rev | get-fallback-bookmark) 
    )

    let res = jj bookmark create -r $rev $bookmark | complete
    if $res.exit_code != 0 and $res.stderr !~ "Bookmark already exists" {
        error make $"Error creating bookmark: ($res.stderr)"
    }
    $bookmark
}
