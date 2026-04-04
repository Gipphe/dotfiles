#!/usr/bin/env fish

if test (count $argv) != 0
    echo "This script expects no arguments" >&2
    exit 1
end

set -l kinds fix feat refactor docs test style chore revert
set -l type $(gum choose $kinds)
or exit $status
set -l scope $(gum input --placeholder "scope")
or exit $status

if test -n "$scope"
    set scope "($scope)"
end

set -l summary $(gum input --value "$type$scope: " --placeholder "Summary of this change.")
or exit $status
set -l description $(gum write --placeholder "Details of this change.")
or exit $status

gum confirm "Commit changes?" && git commit -m "$summary" -m "$description"
or exit $status
