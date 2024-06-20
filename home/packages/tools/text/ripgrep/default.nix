{ lib, config, ... }:
{
  options.gipphe.programs.ripgrep.enable = lib.mkEnableOption "ripgrep";
  config = lib.mkIf config.gipphe.programs.ripgrep.enable { programs.ripgrep.enable = true; };
}
