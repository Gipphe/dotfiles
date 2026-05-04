{ util, pkgs, ... }:
util.mkProgram {
  name = "rustdesk-client";
  hm = {
    home.packages = [ pkgs.rustdesk-flutter ];
  };
  system-nixos = {
    networking.firewall.allowedTCPPorts = [ 21118 ];
  };
}
