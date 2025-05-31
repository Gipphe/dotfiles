{ util, ... }:
util.mkProfile "desktop-normal" {
  gipphe.environment = {
    desktop.plasma.enable = true;
    display.enable = true;
    x.enable = true;
  };
}
