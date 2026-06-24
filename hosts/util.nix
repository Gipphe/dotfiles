{ lib, ... }:
let
  inherit (lib) pipe filterAttrs mergeAttrsList;
  inherit (builtins) readDir attrNames;
in
{
  machines = pipe ../machines [
    readDir
    (filterAttrs (_: t: t == "directory"))
    attrNames
    (map (x: {
      ${x} = import ../machines/${x}/host.nix;
    }))
    mergeAttrsList
    (filterAttrs (_: v: v.enable))
  ];
}
