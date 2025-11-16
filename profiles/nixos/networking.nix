{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "networking";
  shared.gipphe = {
    system.networking.enable = true;
  };
}
