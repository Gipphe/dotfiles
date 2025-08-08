function map_set --argument-names dict key value
    if contains "$dict" -h --help || test -z "$dict" || test -z "$key" || test -z "$value"
        echo "Usage: map_set <dict> <key> <value>" >&2
        exit 0
    end
    map_setup
    set -g $dict$dict_sep$key $value
    set -ag keys$dict_sep$dict $key
    set -ag values$dict_sep$dict $value
end
