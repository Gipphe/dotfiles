{
  den.aspects.programs.rustdesk-client = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.rustdesk-flutter ];
    };
    nixos = {
      networking.firewall.allowedTCPPorts = [ 21118 ];
    };
  };
}
