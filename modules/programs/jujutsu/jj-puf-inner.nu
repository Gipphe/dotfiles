#!/usr/bin/env nu

# Push a bookmark and create its pull request.
#
# If the bookmark's parent is not directly on top of trunk, and that parent
# already has a bookmark with an open PR (i.e. it was itself pushed via this
# same command), the new PR is created with `--base` pointed at the parent's
# bookmark, and a "Depends on #<PR>" line is appended to the PR body so that
# tools like dpulls can flag the stacked dependency.
def main [jj_dir: string, bookmark: string]: nothing -> nothing {
    let jj = $"($jj_dir)/bin/jj"
    ^$jj pub $bookmark

    let parent = $"($bookmark)-"
    let parent_on_trunk = ^$jj log --no-graph -T "commit_id" -r $"($parent) & trunk\()"
    let stacked = $parent_on_trunk | str trim | is-empty

    let deets = if $stacked {
        let parent_bookmark = ^$jj bb $parent | str trim

        if ($parent_bookmark | is-empty) {
            error make {
                msg: 'The bookmark has a parent, but that parent does not have a bookmark.'
                labels: [
                    {
                        text: 'bookmark'
                        span: (metadata $bookmark).span
                    }
                ]
            }
        } else {
            let pr_number = ^gh pr view $parent_bookmark --json number --template "{{.number}}" | str trim

            if ($pr_number | is-empty) {
                error make {
                    msg: 'The bookmark has a parent bookmark, but there is no pull request associated with that bookmark'
                    labels: [
                        {
                            text: 'bookmark'
                            span: (metadata $bookmark).span
                        }
                    ]
                }
            }
            {base: $parent_bookmark, depends_on: $pr_number}
        }
    }

    if ($deets | is-not-empty) and ($deets.base | is-not-empty) and ($deets.depends_on | is-not-empty) {
        ^gh pr create --fill-first --no-maintainer-edit --assignee "@me" -H $bookmark --base $deets.base
        let body = (^gh pr view $bookmark --json body --template "{{.body}}")
        let sep = if ($body | str trim | is-empty) { "" } else { "\n\n" }
        if $body !~ $"Depends on #($deets.depends_on)" {
            ^gh pr edit $bookmark --body $"($body)($sep)Depends on #($deets.depends_on)"
        }
    } else {
        ^gh pr create --fill-first --no-maintainer-edit --assignee "@me" -H $bookmark
    }

    ^gh pr merge --auto --squash --delete-branch $bookmark
}
