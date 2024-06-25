{ lib, ... }:
{
  options.gipphe.programs.nix.enable = lib.mkEnableOption "nix";
}
