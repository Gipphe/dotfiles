{ util, ... }:
util.mkProfile "desktop-mylinux4work" {
  gipphe.environment = {
    desktop.mylinux4work.enable = true;
    display.enable = true;
    wayland.enable = true;
  };
}
