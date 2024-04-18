{ lib, ... }:
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

  importSiblings =
    let
      go =
        l: k: v:
        l ++ (if k != "default.nix" then [ k ] else [ ]);
    in
    dir:
    lib.pipe dir [
      builtins.readDir
      (lib.attrsets.foldlAttrs go [ ])
      (builtins.map (f: ./${f}))
    ];
in
{
  inherit recursiveMap importSiblings;
}
