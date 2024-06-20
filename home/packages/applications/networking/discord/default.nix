{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.discord.enable = lib.mkEnableOption "discord";
  config = lib.mkIf config.gipphe.programs.discord.enable { home.packages = with pkgs; [ discord ]; };
}
