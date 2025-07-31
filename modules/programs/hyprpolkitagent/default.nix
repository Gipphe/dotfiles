{ util, config, ... }:
util.mkProgram {
  name = "hyprpolkitagent";
  hm.services.hyprpolkitagent.enable = config.gipphe.programs.hyprland.enable;
}
