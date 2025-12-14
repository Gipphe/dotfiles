{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "camera";
  shared.gipphe.system.camera.enable = true;
}
