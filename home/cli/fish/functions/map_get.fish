function map_get --argument-names dict key
    map_setup
    if map_contains $dict $key
        eval echo \$$dict$dict_sep$key
    else
        return 1
    end
end
