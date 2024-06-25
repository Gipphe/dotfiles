{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.bat.enable { programs.bat.enable = true; };
}
