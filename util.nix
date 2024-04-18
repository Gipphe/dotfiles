let
  inherit (builtins)
    isList
    isAttrs
    listToAttrs
    attrNames
    ;

  recursiveMap =
    f: x:
    let
      recurseAttrs =
        set:
        listToAttrs (
          map (k: {
            name = k;
            value = recursiveMap f set.${k};
          }) (attrNames set)
        );
      recurseList = list: map (recursiveMap f) list;
    in
    if isList x then
      recurseList x
    else if isAttrs x then
      recurseAttrs x
    else
      f x;
in
{
  inherit recursiveMap;
}
