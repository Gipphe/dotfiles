{ config, lib, ... }:
let
  cfg = config.gipphe.programs.zellij;
in
{
  options.gipphe.programs.zellij = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = !config.programs.tmux.enable;
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "zellij/layouts".source = ./layouts;
      "zellij/config.kdl".text = ''
        copy_command "xclip -in -sel clip"
        copy_on_select true
        theme "catppuccin-macchiato"
        keybinds {
          shared_except "locked" {
            bind "Ctrl q" {}
            bind "Ctrl Alt q" { Quit; }
          }
        }
        ui {
          pane_frames {
            rounded_corners false
          }
        }
      '';
    };
    programs = {
      zellij.enable = true;

      fish = lib.mkIf config.programs.zellij.enable {
        shellAbbrs = {
          tmux = "zellij";
          mux = "zellij --layout";
        };
      };
    };
  };
}
