{ util, pkgs, ... }:
util.mkProgram {
  name = "waydroid";
  nixos = {
    virtualisation.waydroid = {
      enable = true;
    };
    # For sharing clipboard
    environment.systemPackages = [ pkgs.wl-clipboard ];
  };
}
