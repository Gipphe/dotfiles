{ util, ... }:
util.mkToggledModule [ "profiles" "desktop" ] {
  name = "plasma";
  shared.gipphe = {
    system.xdg.enable = true;
    programs = {
      plasma6.enable = true;
      sddm.enable = true;
      plymouth.enable = true;
      cliphist.enable = true;
      clipse.enable = true;
      pinentry-curses.enable = true;
      wl-clipboard.enable = true;
      wezterm.enable = true;
    };
  };
}
