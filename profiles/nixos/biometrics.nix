{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "biometrics";
  # Use fprintd-enroll to enroll finger prints
  shared.gipphe.system.fprint.enable = true;
}
