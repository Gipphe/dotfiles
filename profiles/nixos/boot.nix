{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "boot";
  shared.gipphe.boot.systemd-boot.enable = true;
}
