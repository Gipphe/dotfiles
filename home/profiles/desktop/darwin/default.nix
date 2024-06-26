{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.darwin.enable = lib.mkEnableOption "desktop.darwin profile";
  config = lib.mkIf config.gipphe.profiles.desktop.darwin.enable {
    gipphe.programs = {
      alt-tab.enable = true;
      karabiner-elements.enable = true;
      linearmouse.enable = true;
      xnviewmp.enable = true;
    };
  };
}
