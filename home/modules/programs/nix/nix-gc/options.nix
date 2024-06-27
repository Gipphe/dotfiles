{ lib, ... }:
{
  options.gipphe.programs.nix.gc.enable = lib.mkEnableOption "nix.gc";
}
