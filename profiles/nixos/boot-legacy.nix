{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "boot-legacy";
  shared.gipphe.boot.grub.enable = true;
}
