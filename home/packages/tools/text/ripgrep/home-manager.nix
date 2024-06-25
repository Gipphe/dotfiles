{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.ripgrep.enable { programs.ripgrep.enable = true; };
}
