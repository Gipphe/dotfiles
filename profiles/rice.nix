{ util, ... }:
util.mkProfile "rice" {
  gipphe.environment = {
    rice.enable = true;
    wallpaper.small-memory.enable = true;
    stylix.enable = true;
  };
}
