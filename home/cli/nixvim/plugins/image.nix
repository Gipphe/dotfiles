{ config, ... }:
{
  programs.nixvim.plugins.image = {
    enable = true;
    tmuxShowOnlyInActiveWindow = config.programs.tmux.enable;
  };
}
