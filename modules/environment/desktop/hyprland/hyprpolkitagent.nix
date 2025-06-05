{ util, ... }:
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "hyprpolkitagent";
  hm.services.hyprpolkitagent.enable = true;
}
