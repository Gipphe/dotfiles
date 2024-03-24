function map_contains --argument-names dict key
    set -q $dict$dict_sep$key
    return $status
end
