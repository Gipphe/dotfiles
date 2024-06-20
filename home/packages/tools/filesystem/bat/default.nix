{ lib, config, ... }:
{
  options.gipphe.programs.bat.enable = lib.mkEnableOptions "bat";
  config = lib.mkIf config.gipphe.programs.bat.enable {
    bat = {
      enable = true;
      config = {
        pager = "less -FXR";
      };
    };
  };
}
