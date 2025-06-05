{
  util,
  config,
  pkgs,
  ...
}:
let
  reload_hyprpaper_script = pkgs.writeShellScriptBin "reload-hyprpaper.sh" ''
    ${pkgs.killall}/bin/killall hyprpaper
    sleep 1
    ${config.services.hyprpaper.package}/bin/hyprpaper &
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
      # Started through systemd by home-manager config
      # exec-once = [
      #   "${config.services.hyprpaper.package}/bin/hyprpaper"
      # ];
    };
  };
}
