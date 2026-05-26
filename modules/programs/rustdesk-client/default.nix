{ util, pkgs, ... }:
util.mkProgram {
  name = "rustdesk-client";
  home-manager = {
    home.packages = [ pkgs.rustdesk-flutter ];
  };
  nixos = {
    networking.firewall.allowedTCPPorts = [ 21118 ];
  };
}
