{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.profiles.rice.enable = lib.mkEnableOption "rice";
  config = lib.mkIf config.gipphe.profiles.rice.enable {
    gipphe.environment = {
      rice.enable = true;
      wallpaper.small-memory.enable = true;
      theme.catppuccin.enable = lib.mkIf pkgs.stdenv.isDarwin true;
    };
  };
}
