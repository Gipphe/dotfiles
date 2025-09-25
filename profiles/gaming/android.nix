{ util, ... }:
util.mkToggledModule [ "profiles" "gaming" ] {
  name = "android";
  shared.gipphe.programs = {
    # Requires manual setup described here:
    # https://wiki.nixos.org/wiki/Waydroid
    waydroid.enable = true;
  };
}
