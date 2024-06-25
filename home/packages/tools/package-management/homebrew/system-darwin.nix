{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.homebrew.enable { homebrew.enable = true; };
}
