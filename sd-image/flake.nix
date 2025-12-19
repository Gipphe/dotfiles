{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations.sodium = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            networking = {
              hostName = "sodium";
              wireless = {
                enable = true;
                userControlled.enable = true;
                iwd.enable = false;
                scanOnLowSignal = false;
                networks = {
                  "GiphtNet".psk = "giphthopp";
                };
              };
            };
            users.users.gipphe = {
              extraGroups = [ "wheel" ];
              isNormalUser = true;
              home = "/home/gipphe";
              group = "gipphe";
              initialPassword = "gipphe";
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1qNZ75DNoJXpoAnEXKQzrLYWw6WyQIcnW0c6E1+9Sa gipphe@argon"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABZJhUC80F6MMN4++EiNuWdnlVMQBuXGxRM1t2Hz4Og gipphe@boron"
              ];
            };
            users.groups.gipphe = { };
            nix.settings = {
              allowed-users = [
                "@wheel"
                "root"
              ];
              trusted-users = [
                "@wheel"
                "root"
              ];
            };
            services.openssh.enable = true;
            system.stateVersion = "26.05";
          }
        ];
      };
    };
}
