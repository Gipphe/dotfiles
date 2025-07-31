{ util, ... }:
util.mkProgram {
  name = "hyprpaper";
  hm = {
    services.hyprpaper = {
      enable = true;
      settings = {
        # Getting wallpaper from stylix
        splash = false;
      };
    };
  };
}
