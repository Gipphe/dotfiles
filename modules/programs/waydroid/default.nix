{ util, pkgs, ... }:
util.mkProgram {
  name = "waydroid";
  system-nixos = {
    virtualisation.waydroid = {
      enable = true;
    };
    environment.systemPackages = [ pkgs.wl-clipboard ];
  };
}
