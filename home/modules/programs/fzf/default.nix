{ lib, config, ... }:
{
  options.gipphe.programs.fzf.enable = lib.mkEnableOption "fzf";
  hm = lib.mkIf config.gipphe.programs.fzf.enable { programs.fzf.enable = true; };
}
