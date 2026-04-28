let
  nullAttrs =
    x: builtins.filter (n: !(builtins.hasAttr n x) || x.${n} == null) (builtins.attrNames x);

  removeNullAttrs = x: removeAttrs x (nullAttrs x);

  removeNullAttrsRecursive =
    x:
    let
      attrNames = builtins.attrNames x;
      attrAttrs = builtins.filter (n: builtins.isAttrs x.${n}) attrNames;
      recursed = builtins.listToAttrs (
        map (n: {
          name = n;
          value = removeNullAttrsRecursive x.${n};
        }) attrAttrs
      );
    in
    removeNullAttrs x // recursed;
in
{
  inherit
    nullAttrs
    removeNullAttrs
    removeNullAttrsRecursive
    ;
}
