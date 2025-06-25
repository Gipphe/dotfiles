{ util, ... }:
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "swaync";
  hm.services.swaync = {
    enable = true;
  };
}
