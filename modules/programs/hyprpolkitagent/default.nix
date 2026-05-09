{ util, config, ... }:
util.mkProgram {
  name = "hyprpolkitagent";
  home-manager.services.hyprpolkitagent.enable = config.gipphe.programs.hyprland.enable;
}
