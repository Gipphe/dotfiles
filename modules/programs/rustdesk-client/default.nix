{ util, pkgs, ... }:
util.mkProgram {
  name = "rustdesk-client";
  homeManager = {
    home.packages = [ pkgs.rustdesk-flutter ];
  };
  nixos = {
    networking.firewall.allowedTCPPorts = [ 21118 ];
  };
}
