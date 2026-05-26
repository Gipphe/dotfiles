{
  lib,
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
  homeManager.stylix.image = config.environment.wallpaper.small-memory.image;
}
