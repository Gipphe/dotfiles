{ nixpkgs, self, ... }@inputs:
let
  machines = {
    Jarle = {
      system = "x86_64-linux";
      gipphe.machine = "Jarle";
    };
    nixos-vm = {
      system = "x86_64-linux";
      gipphe.machine = "nixos-vm";
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
          personal.enable = false;
        };
        bootloader.type = "grub";
        virtualisation = {
          virtualbox = true;
        };
      };
    };
    trond-arne = {
      system = "x86_64-linux";
      gipphe.machine = "trond-arne";
      flags = {
        user = {
          username = "gipphe";
          homeDirectory = "/home/gipphe";
        };
        system = {
          type = "nixos";
          homeFonts = true;
          secrets = true;
          systemd = true;
        };
        use-case = {
          work = false;
          cli = true;
          personal = {
            enable = true;
            gaming = true;
          };
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
        bootloader.type = "efi";
        aux = {
          networkmanager = true;
          audio = true;
          printer = false;
          nvidia = false;
        };
      };
    };
    VNB-MB-Pro = {
      system = "aarch64-darwin";
      gipphe.machine = "VNB-MB-Pro";
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
          personal.enable = false;
        };
        aux = {
          audio = false;
        };
        stylix = {
          cursor = false;
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
  inherit (nixpkgs.lib) nixosSystem hasSuffix;
  inherit (inputs.darwin.lib) darwinSystem;
  nixosMachines = filterAttrs (_: config: !(hasSuffix "darwin" config.system)) machines;
  darwinMachines = filterAttrs (_: config: hasSuffix "darwin" config.system) machines;
  machineOptions = mapAttrs (
    hostname: config:
    nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./flags.nix
        {
          gipphe.flags = {
            system = config.system;
          } // (config.flags or { });
        }
      ];
    }
  ) machines;
  nixosConfigurations = mapAttrs (mkMachine nixosSystem) nixosMachines;
  darwinConfigurations = mapAttrs (mkMachine darwinSystem) darwinMachines;
  utilPkgs = nixpkgs.legacyPackages."x86_64-linux";

  mkMachine =
    mkSystem: hostname: config:
    mkSystem {
      inherit (config) system;
      specialArgs = {
        inherit inputs self;
        inherit (machineOptions.${hostname}.config.gipphe) flags;
        utils = import ./util.nix { inherit (utilPkgs) writeShellScriptBin lib system; };
      };
      modules = [ ./home ];
    };
in
{
  inherit nixosConfigurations;
  inherit darwinConfigurations;
  inherit machineOptions;
}
