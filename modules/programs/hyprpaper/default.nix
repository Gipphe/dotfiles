{ util, config, ... }:
util.mkProgram {
  name = "hyprpaper";
  hm = {
    services.hyprpaper = {
      enable = config.gipphe.programs.hyprland.enable;
      settings = {
        # Getting wallpaper from stylix
        splash = false;
      };
    };
  };
}
