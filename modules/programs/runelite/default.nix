{ util, pkgs, ... }:
util.mkProgram {
  name = "runelite";
  hm = {
    home.packages = [ pkgs.runelite ];
    wayland.windowManager.hyprland.settings.windowrule = [
      "nofocus, floating:1, class:net-runelite-client-RuneLite, title:^(win\d+)$"
    ];
  };
}
