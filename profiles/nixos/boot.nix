{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "boot";
  shared.gipphe.boot.limine.enable = true;
}
