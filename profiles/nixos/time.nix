{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "time";
  shared.gipphe.programs = {
    automatic-timezoned.enable = true;
    chrony.enable = true;
  };
}
