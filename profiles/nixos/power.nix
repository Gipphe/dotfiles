{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "power";
  shared.gipphe.programs.upower.enable = true;
}
