{ util, ... }:
util.mkProfile {
  name = "rice";
  shared.gipphe.environment = {
    stylix.enable = true;
    wallpaper.small-memory.enable = true;
  };
}
