{ lib, ... }:
let
  inherit (lib) pipe filterAttrs mergeAttrsList;
  inherit (builtins)
    readDir
    attrNames
    map
    ;
in
{
  enumerateMachines =
    path:
    pipe path [
      readDir
      (filterAttrs (_: t: t == "directory"))
      attrNames
      (map (x: {
        ${x} = import "${path}/${x}/host.nix";
      }))
      mergeAttrsList
      (filterAttrs (_: v: v.enable))
    ];
}
