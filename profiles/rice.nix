{ util, ... }:
util.mkProfile "rice" {
  gipphe.environment = {
    stylix.enable = true;
    wallpaper.small-memory.enable = true;
  };
}
