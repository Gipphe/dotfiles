function map_contains --argument-names dict key
    if contains "$dict" -h --help || test -z "$dict" || test -z "$key"
        echo "Usage: map_set <dict> <key> <value>" >&2
        exit 0
    end
    set -q $dict$dict_sep$key
    return $status
end
