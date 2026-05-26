{ util, config, ... }:
util.mkProgram {
  name = "hyprpolkitagent";
  homeManager.services.hyprpolkitagent.enable = config.gipphe.programs.hyprland.enable;
}
