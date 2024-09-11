{ util, ... }:
util.mkProgram {
  name = "apple.dock";
  system-darwin.system.defaults.CustomUserPreferences."com.apple.dock" = {
    autohide-delay = 0.0;
    autohide-time-modifier = 0.5;
    magnification = false;
    mineffect = "scale";
    show-process-indicators = true;
    show-recents = false;
    static-only = true;
  };
}
