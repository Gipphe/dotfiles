{ lib, ... }:
{
  options.gipphe.programs.discord.enable = lib.mkEnableOption "discord";
}
