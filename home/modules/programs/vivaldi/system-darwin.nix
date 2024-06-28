{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.vivaldi.enable { homebrew.casks = [ "vivaldi" ]; };
}
