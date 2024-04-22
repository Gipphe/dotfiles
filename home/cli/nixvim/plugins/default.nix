{ lib, ... }:
let
  inherit (import ../../../../util.nix { inherit lib; }) importSiblings;
  imports = builtins.map (x: ./${x}) (importSiblings ./.);
in
{
  inherit imports;
}
