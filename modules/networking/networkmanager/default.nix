{ util, config, ... }:
util.mkToggledModule [ "networking" ] {
  name = "networkmanager";
  system-nixos = {
    networking = {
      networkmanager.enable = true;
    };
    users.users.${config.gipphe.username}.extraGroups = [ "networkmanager" ];

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # slows down boot time
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
