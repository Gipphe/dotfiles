{ lib, config, ... }:
{
  options.gipphe.programs.nnn.enable = lib.mkEnableOption "nnn";
  config = lib.mkIf config.gipphe.programs.nnn.enable { programs.nnn.enable = true; };
}
