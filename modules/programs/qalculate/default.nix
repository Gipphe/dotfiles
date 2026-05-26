{ util, pkgs, ... }:
util.mkProgram {
  name = "qalculate";
  homeManager = {
    home.packages = [ pkgs.qalculate-qt ];
    wayland.windowManager.hyprland.settings.window_rule = [
      {
        match.initial_class = "io.github.Qalculate.qalculate-qt";
        float = true;
        size = "(monitor_w * 0.5) (monitor_h * 0.5)";
        center = true;
      }
    ];
  };
}
