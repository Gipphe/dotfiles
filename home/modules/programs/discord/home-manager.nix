{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.discord.enable { home.packages = with pkgs; [ discord ]; };
}
