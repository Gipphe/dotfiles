{ util, pkgs, ... }:
let
  reload_hyprpaper_script = pkgs.writeShellScriptBin "reload-hyprpaper.sh" ''
    systemctl --user restart hyprpaper.service
  '';
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "hyprpaper";
  hm = {
    services.hyprpaper = {
      enable = true;
      settings = {
        # Getting wallpaper from stylix
        splash = false;
      };
    };
    wayland.windowManager.hyprland.settings = {
      bind = [
        # Reload hyprpaper after changing wallpaper
        "$mod SHIFT, W, exec, ${reload_hyprpaper_script}/bin/reload-hyprpaper.sh"
      ];
    };
  };
}
