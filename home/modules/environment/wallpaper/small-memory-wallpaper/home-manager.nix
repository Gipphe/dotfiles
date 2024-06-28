{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.environment.wallpaper.small-memory.enable {
    stylix.image = ./wallpaper/Macchiato-hald8-wall.png;
    home.activation = lib.mkIf pkgs.stdenv.isDarwin {
      set-wallpaper = ''
        run /usr/bin/automator -i "${./wallpaper/dynamic.heic}" "${./automator/set_desktop_wallpaper.workflow}"
      '';
    };
  };
}
