{ lib, config, ... }:
let
  inherit (config.gipphe.profiles) desktop;
in
{
  options.gipphe.profiles.desktop.darwin.logitech.enable = lib.mkEnableOption "desktop.darwin.logitech profile";
  config = lib.mkIf (desktop.enable && desktop.darwin.enable && desktop.darwin.logitech.enable) {
    gipphe.programs.logi-options-plus.enable = true;
  };
}
