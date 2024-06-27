{ lib, config, ... }:
{
  options.gipphe.profiles.logitech.enable = lib.mkEnableOption "logitech profile";
  config = lib.mkIf config.gipphe.profiles.logitech.enable {
    gipphe.programs.logi-options-plus.enable = true;
  };
}
