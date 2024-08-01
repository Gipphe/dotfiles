{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  options.gipphe.programs.apple.finder.enable = lib.mkEnableOption "finder";
  system-darwin = lib.mkIf config.gipphe.programs.apple.finder.enable {
    system.defaults.CustomUserPreferences."com.apple.finder" = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      _FXSortFoldersFirst = true;
      CreateDesktop = false;
    };
  };
}
