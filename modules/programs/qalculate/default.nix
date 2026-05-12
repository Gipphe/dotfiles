{ util, pkgs, ... }:
util.mkProgram {
  name = "qalculate";
  home-manager = {
    home.packages = [ pkgs.qalculate-qt ];
    gipphe.programs.hyprland.settings.windowRules = [
      {
        match.initialClass = "io.github.Qalculate.qalculate-qt";
        float = true;
        size = "(monitor_w * 0.5) (monitor_h * 0.5)";
        center = true;
      }
    ];
  };
}
