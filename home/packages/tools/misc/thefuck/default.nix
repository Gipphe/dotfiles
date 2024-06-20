{ lib, config, ... }:
{
  options.gipphe.programs.thefuck.enable = lib.mkEnableOption "thefuck";
  config = lib.mkIf config.gipphe.programs.thefuck.enable { programs.thefuck.enable = true; };
}
