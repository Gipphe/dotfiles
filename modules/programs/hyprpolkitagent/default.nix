{ util, ... }:
util.mkProgram {
  name = "hyprpolkitagent";
  hm.services.hyprpolkitagent.enable = true;
}
