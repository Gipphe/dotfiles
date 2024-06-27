function map_set --argument-names dict key value
    map_setup
    set -g $dict$dict_sep$key $value
    set -ag keys$dict_sep$dict $key
    set -ag values$dict_sep$dict $value
end
