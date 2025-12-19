{
  hostname,
  util,
  inputs,
  lib,
  ...
}:
let
  host = import ./host.nix;
  username = "gipphe";
in
util.mkToggledModule [ "machines" ] {
  inherit (host) name;

  shared.gipphe = {
    inherit username;
    homeDirectory = "/home/${username}";
    hostName = host.name;
    profiles = {
      nixos = {
        networking.enable = true;
        power.enable = true;
        system.enable = true;
        time.enable = true;
        wifi.enable = true;
      };
      cli-slim.enable = true;
      core.enable = true;
      gc.enable = true;
      keyring.enable = true;
      secrets.enable = true;
    };
  };

  system-nixos = {
    imports = lib.optionals (hostname == host.name) [
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];

    users.users.${username} = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1qNZ75DNoJXpoAnEXKQzrLYWw6WyQIcnW0c6E1+9Sa gipphe@argon"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABZJhUC80F6MMN4++EiNuWdnlVMQBuXGxRM1t2Hz4Og gipphe@boron"
      ];
    };
    services.openssh.enable = true;
    networking.networkmanager.enable = lib.mkForce false;

    system.stateVersion = "26.05";
  };
}
