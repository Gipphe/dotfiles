{ lib, config, ... }:
{
  options.gipphe.profiles.darwin.enable = lib.mkEnableOption "darwin profile";
  config = lib.mkIf config.gipphe.profiles.darwin.enable {
    gipphe.programs = {
      alt-tab.enable = true;
      homebrew.enable = true;
      karabiner-elements.enable = true;
      linearmouse.enable = true;
      xnviewmp.enable = true;
    };
  };
}
