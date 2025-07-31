{ util, ... }:
util.mkProfile "desktop-normal" {
  gipphe.environment = {
    desktop.plasma.enable = true;
    x.enable = true;
  };
  gipphe.programs = {
    sddm.enable = true;
    wl-clipboard.enable = true;
  };
}
