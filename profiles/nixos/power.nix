{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "power";
  shared.gipphe.programs = {
    powertop.enable = true;
    upower.enable = true;
  };
}
