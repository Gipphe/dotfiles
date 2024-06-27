{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.thefuck.enable { programs.thefuck.enable = true; };
}
