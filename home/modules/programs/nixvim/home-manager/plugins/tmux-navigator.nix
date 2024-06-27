{ config, lib, ... }:
{
  config = lib.mkIf config.programs.tmux.enable {
    programs.nixvim.plugins.tmux-navigator.enable = true;
  };
}
