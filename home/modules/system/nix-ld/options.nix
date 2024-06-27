{ lib, ... }:
{
  options.gipphe.system.nix-ld.enable = lib.mkEnableOption "nix-ld";
}
