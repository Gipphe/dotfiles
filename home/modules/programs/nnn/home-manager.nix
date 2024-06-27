{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.nnn.enable { programs.nnn.enable = true; };
}
