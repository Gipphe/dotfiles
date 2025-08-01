{ util, ... }:
util.mkProfile {
  name = "desktop-normal";
  shared.gipphe.programs = {
    plasma6.enable = true;
    sddm.enable = true;
    wl-clipboard.enable = true;
  };
}
