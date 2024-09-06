{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  options.gipphe.programs.apple.dock.enable = lib.mkEnableOption "apple.dock";
  system-darwin = lib.mkIf config.gipphe.programs.apple.dock.enable {
    system.defaults.CustomUserPreferences."com.apple.dock" = {
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      magnification = false;
      mineffect = "scale";
      show-process-indicators = true;
      show-recents = false;
      static-only = true;
    };
  };
}
