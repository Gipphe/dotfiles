{ lib, util, ... }:
let
  host = import ./host.nix;
in
util.mkToggledModule [ "machines" ] {
  inherit (host) name;
  shared = {
    gipphe = {
      username = "nix-on-droid";
      homeDirectory = "/data/data/com.termux.nix/files/home";
      hostName = host.name;
      profiles = {
        android.enable = true;
        cli-slim.enable = true;
        core.enable = true;
        fonts.enable = true;
        gc.enable = true;
        rice.enable = false;
        secrets.enable = false;
      };
    };
    # SSH setup requires sops-nix, which isn't supported on nix-on-droid
    gipphe.programs.ssh.enable = lib.mkForce false;
  };
  system-droid.system.stateVersion = lib.mkForce "24.05";
}
