{ config, lib, ... }:
{
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

  programs.tmux.enable = lib.mkIf config.programs.zellij.enable false;
  programs.fish = lib.mkIf config.programs.zellij.enable {
    shellAbbrs = {
      tmux = "zellij";
    };
  };
}
