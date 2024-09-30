{ util, ... }:
util.mkEnvironment {
  name = "rice";

  system-darwin.system.defaults = {
    # ".GlobalPreferences"."com.apple.mouse.scaling" = 1;
    CustomUserPreferences = {
      "com.apple.dock"."workspaces-swoosh-animation-off" = true;
    };
  };
}
