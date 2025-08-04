{ util, ... }:
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "plasma";
  shared.gipphe.programs = {
    plasma6.enable = true;
    sddm.enable = true;
    pinentry-curses.enable = true;
    wl-clipboard.enable = true;
  };
}
