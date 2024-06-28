{ lib, config, ... }:
{
  options.gipphe.profiles.rice.enable = lib.mkEnableOption "rice";
  config = lib.mkIf config.gipphe.profiles.rice.enable {
    gipphe.environment = {
      rice.enable = true;
      wallpaper.small-memory.enable = true;
    };
  };
}
