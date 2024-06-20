{ lib, config, ... }:
let
  inherit (config.gipphe.profiles) desktop;
in
{
  options.gipphe.profiles.desktop.gaming.enable = lib.mkEnableOption "desktop.gaming profile";
  config = lib.mkIf (desktop.enable && desktop.gaming.enable) {
    gipphe.programs = {
      lutris.enable = true;
      discord.enable = true;
    };
  };
}
