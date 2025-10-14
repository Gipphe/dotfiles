{
  inputs,
  util,
  lib,
  pkgs,
  config,
  ...
}:
let
  hmCfg = config.programs.walker;
  theme = pkgs.fetchFromGitHub {
    owner = "Krymancer";
    repo = "walker";
    rev = "15ad25fc3ad5496094ece50300da2ac6bc355efe";
    hash = "sha256-Fqh6/GEn2y7N5IBLSnva5djzADqpivIE321EREtpCSE=";
  };
  defaultConfig = lib.importTOML "${inputs.walker}/resources/config.toml";
in
util.mkProgram {
  name = "walker";
  hm = {
    imports = [
      inputs.walker.homeManagerModules.walker
    ];
    config = {
      home.packages = [
        pkgs.libqalculate
      ];
      # xdg.configFile = {
      #   "walker/themes/catppuccin-macchiato.toml".source = "${theme}/themes/macchiato.toml";
      #   "walker/themes/catppuccin-macchiato.css".source = "${theme}/themes/macchiato.css";
      # };

      programs = {
        walker = {
          enable = true;
          runAsService = true;
          config = lib.recursiveUpdate defaultConfig {
            # theme = "catppuccin-macchiato";
            force_keyboard_focus = true;
          };
          themes.catppuccin-macchiato = {
            style = builtins.readFile "${theme}/themes/macchiato.css";
          };
        };
      };

      gipphe.core.wm.binds = [
        {
          mod = "Mod";
          key = "space";
          action.spawn = "${lib.getExe hmCfg.package}";
        }
        {
          mod = "Mod";
          key = "Tab";
          action.spawn = "${lib.getExe hmCfg.package} --modules windows";
        }
      ];
    };
  };
}
