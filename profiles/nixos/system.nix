{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "system";
  shared.gipphe.system = {
    console.enable = true;
    dconf.enable = true;
    journald.enable = true;
    localization.enable = true;
    nix-ld.enable = true;
    systemd.enable = true;
  };
}
