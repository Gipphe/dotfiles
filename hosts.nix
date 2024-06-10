{ nixpkgs, self, ... }@inputs:
let
  nixosConfigs = {
    Jarle = {
      system = "x86_64-linux";
      flags = {
        user = {
          username = "gipphe";
          homeDirectory = "/home/gipphe";
        };
        system = {
          type = "nixos";
          homeFonts = true;
          systemd = true;
          secrets = true;
        };
        use-case = {
          cli = true;
          gaming = false;
          work = true;
        };
        virtualisation = {
          wsl = true;
          virtualbox = false;
        };
        desktop = {
          enable = false;
        };
        aux = {
          audio = false;
          networkmanager = false;
          printer = false;
        };
      };
    };
    nixos-vm = {
      system = "x86_64-linux";
      flags = {
        user = {
          username = "gipphe";
          homeDirectory = "/home/gipphe";
        };
        system = {
          type = "nixos";
          secrets = true;
        };
        use-case = {
          work = false;
        };
        bootloader = "grub";
        virtualisation = {
          virtualbox = true;
        };
      };
    };
    trond-arne = {
      system = "x86_64-linux";
      flags = {
        user = {
          username = "gipphe";
          homeDirectory = "/home/gipphe";
        };
        system = {
          type = "nixos";
          homeFonts = true;
          secrets = true;
        };
        use-case = {
          work = true;
          cli = true;
          gaming = true;
        };
        desktop = {
          enable = true;
          hyprland = false;
          plasma = true;
          wayland = false;
        };
        virtualisation = {
          wsl = false;
          virtualbox = false;
        };
        bootloader = "efi";
        aux = {
          networkmanager = true;
          systemd = true;
          audio = true;
          printer = false;
          nvidia = false;
        };
      };
    };
    VNB-MB-Pro = {
      system = "aarch64-darwin";
      flags = {
        user = {
          username = "victor";
          homeDirectory = "/Users/victor";
        };
        system = {
          type = "nix-darwin";
          homeFonts = false;
          systemd = false;
          secrets = true;
        };
        use-case = {
          work = true;
        };
        aux = {
          audio = false;
        };
        desktop = {
          enable = false;
        };
        virtualisation = {
          wsl = false;
        };
      };
    };
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  inherit (nixpkgs.lib) pipe nixosSystem;
  inherit (inputs.darwin.lib) darwinSystem;
  nixosMachines = filterAttrs (_: config: config.flags.system.type == "nixos") nixosConfigs;
  darwinMachines = pipe nixosConfigs [
    (filterAttrs (_: config: config.flags.system.type == "nix-darwin"))
    (mapAttrs (_: c: filterAttrs (k: _: k == "system") c))
  ];
  machineOptions = mapAttrs (
    hostname: config:
    nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./flags.nix
        { gipphe.flags.system.hostname = nixpkgs.lib.mkDefault hostname; }
        { gipphe.flags = config.flags; }
      ];
    }
  ) nixosConfigs;
  nixosConfigurations = mapAttrs (mkMachine nixosSystem) nixosMachines;

  darwinConfigurations = mapAttrs (mkMachine darwinSystem) darwinMachines;

  mkMachine =
    mkSystem: hostname: config:
    mkSystem {
      inherit (config) system;
      specialArgs = {
        inherit inputs self;
        inherit (machineOptions.${hostname}.config.gipphe) flags;
      };
      modules = [ ./system ];
    };
in
{
  inherit nixosConfigurations;
  inherit darwinConfigurations;
  inherit machineOptions;
}
