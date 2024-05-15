{ nixpkgs, self, ... }:
let
  inherit (self) inputs;
  core = ../system/core;
  # bootloader = ../system/core/bootloader.nix;
  # impermanence = ../system/core/impermanence.nix;
  # nvidia = ../system/nvidia;
  server = ../system/server;
  # wayland = ../system/wayland;
  nh = inputs.nh.nixosModules.default;
  hw = inputs.nixos.hardware.nixosModules;
  agenix = inputs.agenix.nixosModules.age;
  hmModule = inputs.home-manager.nixosModules.home-manager;
  catppuccinNixos = inputs.catppuccin.nixosModules.catppuccin;
  catppuccinHm = inputs.catppuccin.homeManagerModules.catppuccin;

  shared = [
    core
    agenix
    nh
    {
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 10d";
      };
    }
  ];

  basehm = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.gipphe.imports = [ catppuccinHm ];
  };
  home-manager = basehm // {
    users.gipphe = {
      imports = [ ../home ];
      _module.args.theme = import ../theme;
    };
  };

  hmtty = basehm // {
    users.gipphe = {
      imports = [ ../home/base.nix ];
    };
  };
in
{
  nixosConfigurations = {
    # Test VM for tinkering with NixOS
    nixos-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { networking.hostName = "nixos-vm"; }
        ./nixos-vm
        # nvidia
        # bootloader
        # impermanence
        # wayland
        catppuccinNixos
        hmModule
        { inherit home-manager; }
        { home-manager.users.gipphe.imports = [ ../home/hosts/nixos-vm ]; }
        agenix
      ]; # ++ shared;
      specialArgs = {
        inherit inputs;
      };
    };

    Jarle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { networking.hostName = "Jarle"; }
        ./Jarle
        catppuccinNixos
        hmModule
        { home-manager = hmtty; }
        { home-manager.users.gipphe.imports = [ ../home/hosts/Jarle ]; }
        # agenix
      ];
      specialArgs = {
        inherit inputs;
      };
    };

    # Ideapad laptop
    trond-arne = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { networking.hostName = "trond-arne"; }
        ./trond-arne
        catppuccinNixos
        # bootloader
        # impermanence
        # wayland
        # hw.lenovo-ideapad-z510
        hmModule
        { inherit home-manager; }
        { home-manager.users.gipphe.imports = [ ../home/hosts/trond-arne ]; }
        agenix
      ]; # ++ shared;
      specialArgs = {
        inherit inputs;
      };
    };

    # Raspberry Pi 4
    hydrogen = nixpkgs.lib.nixosSystem {
      system = "aarch64";
      modules = [
        { networking.hostName = "hydrogen"; }
        hw.raspberry-pi-4
        server
        ./hydrogen
      ] ++ shared;

      specialArgs = {
        inherit inputs;
      };
    };
  };

  darwinConfigurations = {
    # Work Macbook Pro
    "VNB-MB-Pro" =
      let
        username = "victor";
        homeDirectory = "/Users/victor";
      in
      inputs.darwin.lib.darwinSystem {
        modules = [
          { networking.hostName = "VNB-MB-Pro"; }
          ./VNB-MB-Pro
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {
                inherit
                  homeDirectory
                  inputs
                  self
                  username
                  ;
              };
              users.${username}.imports = [
                catppuccinHm
                ../home/base.nix
                ../home/hosts/VNB-MB-Pro
              ];
            };
          }
          agenix
        ];
        specialArgs = {
          inherit
            homeDirectory
            inputs
            self
            username
            ;
        };
      };
  };

  homeConfigurations = {
    # Non-NixOS home-manager configuration
    "gipphe@Jarle" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        catppuccinHm
        ../home/base.nix
        ../home/hosts/Jarle
      ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
