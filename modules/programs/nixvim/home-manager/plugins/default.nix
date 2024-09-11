{ lib, ... }:
let
  inherit (builtins) readDir attrNames map;
  imports = lib.pipe ./. [
    readDir
    (lib.attrsets.filterAttrs (name: _: name != "default.nix"))
    attrNames
    (map (x: ./${x}))
  ];
in
{
  inherit imports;
}
