{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "biometrics";
  shared.gipphe.system.fprint.enable = true;
}
