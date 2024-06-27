{ lib, config, ... }:
{
  options.gipphe.profiles.gaming.enable = lib.mkEnableOption "gaming profile";
  config = lib.mkIf config.gipphe.profiles.gaming.enable {
    gipphe.programs = {
      lutris.enable = true;
      discord.enable = true;
    };
  };
}
