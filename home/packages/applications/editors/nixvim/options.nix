{ lib, ... }:
{
  options.gipphe.programs.nixvim.enable = lib.mkEnableOption "nixvim";
}
