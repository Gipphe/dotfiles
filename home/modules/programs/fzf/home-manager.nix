{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.fzf.enable { programs.fzf.enable = true; };
}
