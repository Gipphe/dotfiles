{ util, config, ... }:
util.mkProgram {
  name = "hyprpaper";
  hm = {
    services.hyprpaper = {
      inherit (config.gipphe.programs.hyprland) enable;
      settings = {
        # Getting wallpaper from stylix
        splash = false;
      };
    };
  };
}
