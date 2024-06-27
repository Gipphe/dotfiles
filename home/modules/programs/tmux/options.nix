{ lib, ... }:
{
  options.gipphe.programs.tmux.enable = lib.mkEnableOption "tmux";
}
