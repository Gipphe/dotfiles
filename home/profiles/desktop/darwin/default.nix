{ lib, config, ... }:
let
  inherit (config.gipphe.profiles) desktop;
in
{
  imports = [ ./logitech ];
  options.gipphe.profiles.desktop.darwin.enable = lib.mkEnableOption "desktop.darwin profile";
  config = lib.mkIf (desktop.enable && desktop.darwin.enable) {
    gipphe.programs = {
      xnviewmp.enable = true;
      linearmouse.enable = true;
      alt-tab.enable = true;
      karabiner-elements.enable = true;
    };
  };
}
