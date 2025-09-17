{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "time";
  shared.gipphe.programs.chrony.enable = true;
}
