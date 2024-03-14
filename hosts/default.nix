{ nixpkgs, self, ... }:
let
  inherit (self) inputs;
  core = ../system/core;
  bootloader = ../system/core/bootloader;
  impermanence = ../system/core/impermanence.nix;
  nvidia = ../system/nvidia;
  server = ../system/server;
  wayland = ../system/wayland;
  hw = inputs.nixos.hardware.nixosModules;
  agenix = inputs.agenix.nixosModules.age;
  hmModule = inputs.home-manager.nixosModules.home-manager;

  shared = [
    core
    agenix
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.gipphe = {
      imports = [ ../home ];
      _module.args.theme = import ../theme;
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
        nvidia
        bootloader
        impermanence
        wayland
        hmModule
        { inherit home-manager; }
      ] ++ shared;
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
        bootloader
        impermanence
        wayland
        hmModule
        hw.lenovo-ideapad-z510
        { inherit home-manager; }
      ] ++ shared;
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
    "VNB-MB-Pro" = inputs.darwin.lib.darwinSystem {
      modules = [
        { networking.hostName = "VNB-MB-Pro"; }
        ./darwin/strise-mb
        inputs.home-manager.darwinModules.home-manager
        { inherit home-manager; }
        agenix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
  };

  homeConfigurations = {
    # Non-NixOS home-manager configuration
    gipphe = inputs.home-manager.lib.homeManagerConfiguration { modules = [ ./home ]; };
  };
}
