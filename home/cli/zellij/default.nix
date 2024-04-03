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
    xdg.configFile."zellij/layouts".source = ./layouts;
    programs.zellij = {
      enable = true;
      settings = {
        copy_command = "xclip -in -sel clip";
        copy_on_select = true;
        theme = "catppuccin-macchiato";
        ui = {
          pane_frames = {
            rounded_corners = true;
          };
        };
      };
    };

    programs.fish = lib.mkIf config.programs.zellij.enable {
      shellAbbrs = {
        tmux = "zellij";
      };
    };
  };
}
