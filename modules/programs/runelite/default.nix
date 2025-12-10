{ util, pkgs, ... }:
util.mkProgram {
  name = "runelite";
  hm = {
    home.packages = [ pkgs.runelite ];
    wayland.windowManager.hyprland.settings.windowrule = [
      "no_focus, match:float yes, match:class net-runelite-client-RuneLite, match:title ^(win\d+)$"
    ];
  };
}
