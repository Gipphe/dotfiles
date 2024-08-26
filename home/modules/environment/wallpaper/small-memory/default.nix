{
  lib,
  util,
  pkgs,
  ...
}:
util.mkToggledModule
  [
    "environment"
    "wallpaper"
  ]
  {
    name = "small-memory";
    hm = {
      stylix.image = ./wallpaper/Macchiato-hald8-wall.png;
      home.activation = lib.mkIf pkgs.stdenv.isDarwin {
        set-wallpaper = ''
          run /usr/bin/automator -i "${./wallpaper/dynamic.heic}" "${./automator/set_desktop_wallpaper.workflow}"
        '';
      };
    };
  }
