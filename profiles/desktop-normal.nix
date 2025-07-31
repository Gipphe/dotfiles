{ util, ... }:
util.mkProfile "desktop-normal" {
  gipphe.programs = {
    plasma6.enable = true;
    sddm.enable = true;
    wl-clipboard.enable = true;
  };
}
