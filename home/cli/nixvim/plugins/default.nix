{ lib, ... }:
with builtins;
let
  inherit (lib.attrsets) filterAttrs;
  inherit (import ../../../../util.nix { inherit lib; }) importSiblings;
  dirs = lib.pipe ./. [
    readDir
    (filterAttrs (_: type: type == "directory"))
    attrNames
    (map (x: ./${x}))
  ];
  imports = map (x: ./${x}) (importSiblings ./.) ++ dirs;
in
{
  inherit imports;
}
