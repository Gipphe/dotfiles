{ util, config, ... }:
util.mkProgram {
  name = "hyprpaper";
  home-manager = {
    services.hyprpaper = {
      inherit (config.gipphe.programs.hyprland) enable;
      settings = {
        # Getting wallpaper from stylix
        splash = false;
      };
    };
  };
}
