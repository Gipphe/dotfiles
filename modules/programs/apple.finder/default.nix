{ util, ... }:
util.mkProgram {
  name = "apple.finder";
  system-darwin.system.defaults.CustomUserPreferences."com.apple.finder" = {
    AppleShowAllFiles = true;
    ShowPathbar = true;
    _FXSortFoldersFirst = true;
    CreateDesktop = false;
  };
}
