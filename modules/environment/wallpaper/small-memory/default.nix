{
  lib,
  flags,
  util,
  pkgs,
  config,
  ...
}:
util.mkWallpaper {
  name = "small-memory";
  options.environment.wallpaper.small-memory.image = lib.mkOption {
    description = "Path to wallpaper image";
    type = lib.types.path;
    default = ./wallpaper/Macchiato-hald8-wall.png;
  };
  hm = {
    stylix.image = lib.mkIf (!flags.isNixOnDroid) config.environment.wallpaper.small-memory.image;
    home.activation = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      set-wallpaper = ''
        run /usr/bin/automator -i "${./wallpaper/dynamic.heic}" "${./automator/set_desktop_wallpaper.workflow}" > /dev/null
      '';
    };
  };
}
