{ inputs, util, ... }:
util.mkProgram {
  name = "caelestia-shell";
  hm = {
    imports = [ inputs.caelestia-shell.homeManagerModules.default ];

    home.file."Pictures/Wallpapers/small-memory.png".source =
      ../../environment/wallpaper/small-memory/wallpaper/Macchiato-hald8-wall.png;
    programs.caelestia = {
      enable = true;
      settings = {
        paths.wallpaperDir = "~/Pictures/Wallpapers";
        general.apps = {
          terminal = [ "wezterm" ];
        };
        bar = {
          workspaces = {
            shown = 4;
            showWindows = false;
          };
        };
      };
      cli = {
        enable = true;
        settings = {
          theme.enableGtk = true;
        };
      };
    };

    gipphe.core.wm.binds =
      let
        prefix = "caelestia";
      in
      [
        {
          mod = [ "Mod" ];
          key = "space";
          action.shortcut = "${prefix}:launcher";
        }
        {
          mod = [
            "Mod"
            "Shift"
          ];
          key = "K";
          action.shortcut = "${prefix}:dashboard";
        }
        {
          mod = [
            "Mod"
            "Shift"
          ];
          key = "L";
          action.shortcut = "${prefix}:controlCenter";
        }
        {
          mod = [
            "Mod"
            "Shift"
          ];
          key = "R";
          action.shortcut = "${prefix}:session";
        }
        {
          mod = [ "Mod" ];
          key = "L";
          action.shortcut = "${prefix}:lock";
        }
        {
          mod = [ ];
          key = "Print";
          action.shortcut = "${prefix}:screenshotFreezeClip";
        }
        {
          mod = [ "Alt_L" ];
          key = "Print";
          action.shortcut = "${prefix}:screenshot";
        }
      ];
  };
}
