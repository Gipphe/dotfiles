{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.darwin.logitech.enable = lib.mkEnableOption "desktop.darwin.logitech profile";
  config = lib.mkIf config.gipphe.profiles.desktop.darwin.logitech.enable {
    gipphe.programs.logi-options-plus.enable = true;
  };
}
