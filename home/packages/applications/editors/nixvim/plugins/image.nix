{ config, ... }:
{
  programs.nixvim.plugins.image = {
    enable = false; # Really obnoxious when viewing markdown presentations
    tmuxShowOnlyInActiveWindow = config.programs.tmux.enable;
  };
}
