argparse r/rev= -- $argv
or exit 1

set -l rev $_flag_rev

if test -z "$rev"
    echo "Missing revision" >&2
    exit 1
end

set -l desc (jj show --template description --no-patch "$rev" | head -n 1)
or exit 1

if test -n "$desc" && test "$(string replace -ra '[^:]+' "" "$desc")" = ":"
    set desc (string replace -r '\\)?: ' '/' $desc | string replace -ra '[^\\w/]' '-' | string replace -ra '\'"`' '' | string lower)
    set desc (echo -n "$desc" | tr -sc '/:[:alnum:]' '-' | tr -s ':' '/')
else
    # Fall back to "gipphe/push-<short_id>" if no description
    # is set, or description does not comply with
    # conventional commits.
    set desc "gipphe/push-$(jj show --template short_id --no-path "$rev")"
end

echo "$desc"
