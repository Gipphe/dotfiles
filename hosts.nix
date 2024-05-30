{ nixpkgs, self, ... }@inputs:
let
  # core = ./system/core;
  # bootloader = ./system/core/bootloader.nix;
  # impermanence = ./system/core/impermanence.nix;
  # nvidia = ./system/nvidia;
  # server = ./system/server;
  # wayland = ./system/wayland;
  # nh = inputs.nh.nixosModules.default;
  # hw = inputs.nixos.hardware.nixosModules;
  # agenix = inputs.agenix.nixosModules.age;
  # hmModule = inputs.home-manager.nixosModules.home-manager;
  # catppuccinNixos = inputs.catppuccin.nixosModules.catppuccin;
  catppuccinHm = inputs.catppuccin.homeManagerModules.catppuccin;
  nixosConfigs = {
    Jarle = {
      flags = {
        gui = false;
      };
    };
    nixos-vm = {
      system = "x86_64-linux";
      flags = {
        gui = false;
        grub = true;
        efi = false;
      };
    };
    trond-arne = {
      system = "x86_64-linux";
      flags = {
        hyprland = true;
        wayland = true;
      };
    };
    hydrogen = {
      system = "aarch64-linux";
      flags = {
        gui = false;
      };
    };
    VNB-MB-Pro = {
      system = "aarch64-darwin";
      flags = {
        username = "victor";
        homeDirectory = "/Users/victor";
        hostname = "VNB-MB-Pro";
        gui = false;
      };
    };
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  nixosMachines = filterAttrs (_: config: config.system != "aarch64-darwin") nixosConfigs;
  darwinMachines = filterAttrs (_: config: config.system == "aarch64-darwin") nixosConfigs;
  nixosConfigurations = nixpkgs.lib.attrsets.mapAttrs (mkMachine nixpkgs.lib.nixosSystem) nixosMachines;

  darwinConfigurations = mapAttrs (
    config: mkMachine inputs.darwin.lib.darwinSystem (filterAttrs (k: _: k != "system"))
  ) darwinMachines;

  mkMachine =
    mkSystem: hostname: config:
    mkSystem {
      inherit (config) system;
      specialArgs = {
        inherit inputs self;
      };
      modules = [
        ./system
        ./flags.nix
        { gipphe.flags.hostname = nixpkgs.lib.mkDefault hostname; }
        { gipphe.flags = config.flags or { }; }
      ];
    };
in
# shared = [
#   core
#   agenix
#   nh
#   {
#     nh = {
#       enable = true;
#       clean.enable = true;
#       clean.extraArgs = "--keep-since 10d";
#     };
#   }
# ];
# basehm = {
#   useUserPackages = true;
#   useGlobalPkgs = true;
#   extraSpecialArgs = {
#     inherit inputs;
#     inherit self;
#   };
#   users.gipphe = {
#     imports = [ catppuccinHm ];
#     _module.args.theme = import ./theme;
#   };
# };
# home-manager = basehm // {
#   users.gipphe = {
#     imports = basehm.users.gipphe.imports ++ [ ./home ];
#   };
# };
#
# hmtty = basehm // {
#   users.gipphe = {
#     imports = basehm.users.gipphe.imports ++ [ ./home/base.nix ];
#   };
# };
{
  inherit nixosConfigurations;
  inherit darwinConfigurations;
  # nixosConfigurations = {
  #   # Test VM for tinkering with NixOS
  #   nixos-vm = nixpkgs.lib.nixosSystem {
  #     system = "x86_64-linux";
  #     modules = [
  #       ./system
  #       {
  #         gipphe.flags = {
  #           hostname = "nixos-vm";
  #           gui = false;
  #           grub = true;
  #           efi = false;
  #         };
  #       }
  #     ];
  #     specialArgs = {
  #       inherit inputs self;
  #     };
  #   };
  #
  #   Jarle = nixpkgs.lib.nixosSystem {
  #     system = "x86_64-linux";
  #     modules = [
  #       ./system
  #       ./flags.nix
  #       {
  #         gipphe.flags = {
  #           hostname = "Jarle";
  #           gui = false;
  #         };
  #       }
  #     ];
  #     specialArgs = {
  #       inherit inputs self;
  #     };
  #   };
  #
  #   # Ideapad laptop
  #   trond-arne = nixpkgs.lib.nixosSystem {
  #     system = "x86_64-linux";
  #     modules = [
  #       ./system
  #       {
  #         gipphe.flags = {
  #           hostname = "trond-arne";
  #         };
  #       }
  #     ];
  #     specialArgs = {
  #       inherit inputs self;
  #     };
  #   };
  #
  #   # Raspberry Pi 4
  #   hydrogen = nixpkgs.lib.nixosSystem {
  #     system = "aarch64";
  #     modules = [
  #       ./system
  #       {
  #         gipphe.flags = {
  #           hostname = "hydrogen";
  #         };
  #       }
  #     ];
  #     specialArgs = {
  #       inherit inputs self;
  #     };
  #   };
  # };

  # darwinConfigurations = {
  #   # Work Macbook Pro
  #   "VNB-MB-Pro" = inputs.darwin.lib.darwinSystem {
  #     modules = [
  #       ./flags.nix
  #       ./system
  #       {
  #         gipphe.flags = {
  #           username = "victor";
  #           homeDirectory = "/Users/victor";
  #           hostname = "VNB-MB-Pro";
  #           gui = false;
  #         };
  #       }
  #     ];
  #     specialArgs = {
  #       inherit inputs self;
  #     };
  #   };
  # };

  homeConfigurations = {
    # Non-NixOS home-manager configuration
    "gipphe@Jarle" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        catppuccinHm
        ./home/base.nix
        ./home/hosts/Jarle
      ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
