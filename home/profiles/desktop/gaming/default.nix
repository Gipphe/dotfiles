{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.gaming.enable = lib.mkEnableOption "desktop.gaming profile";
  config = lib.mkIf config.gipphe.profiles.desktop.gaming.enable {
    gipphe.programs = {
      lutris.enable = true;
      discord.enable = true;
    };
  };
}
