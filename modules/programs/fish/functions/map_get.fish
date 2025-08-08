function map_get --argument-names dict key
    if contains "$dict" -h --help || test -z "$dict" || test -z "$key"
        echo "Usage: map_set <dict> <key> <value>" >&2
        exit 0
    end
    map_setup
    if map_contains $dict $key
        eval echo \$$dict$dict_sep$key
    else
        return 1
    end
end
