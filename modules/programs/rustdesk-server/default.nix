{ util, ... }:
util.mkProgram {
  name = "rustdesk-server";
  system-nixos = {
    services.rustdesk-server = {
      enable = true;
      openFirewall = true;
    };
  };
}
