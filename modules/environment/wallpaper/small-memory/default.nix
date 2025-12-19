{
  lib,
  flags,
  util,
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
  hm = lib.optionalAttrs (!flags.isNixOnDroid && flags.stylix) {
    stylix.image = config.environment.wallpaper.small-memory.image;
  };
}
