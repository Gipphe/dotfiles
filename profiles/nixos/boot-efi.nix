{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "boot-efi";
  shared.gipphe.boot.systemd-boot.enable = true;
}
