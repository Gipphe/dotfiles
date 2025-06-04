{ util, ... }:
util.mkProfile "desktop-mylinuxforwork" {
  gipphe.environment = {
    desktop.mylinuxforwork.enable = true;
    display.enable = true;
    wayland.enable = true;
  };
}
