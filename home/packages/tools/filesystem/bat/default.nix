{ lib, config, ... }:
{
  options.gipphe.programs.bat.enable = lib.mkEnableOptions "bat";
  config = lib.mkIf config.gipphe.programs.bat.enable { programs.bat.enable = true; };
}
