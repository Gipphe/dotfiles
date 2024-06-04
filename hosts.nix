{ nixpkgs, self, ... }@inputs:
let
  nixosConfigs = {
    Jarle = {
      system = "x86_64-linux";
      flags = {
        username = "gipphe";
        homeDirectory = "/home/gipphe";
        system = "nixos";
        homeFonts = true;
        gaming = false;
        gui = false;
        wsl = true;
        vscode = true;
        virtualbox = false;
        desktop = false;
        audio = false;
        systemd = true;
        secrets = true;
        networkmanager = false;
        printer = false;
      };
    };
    nixos-vm = {
      system = "x86_64-linux";
      flags = {
        username = "gipphe";
        homeDirectory = "/home/gipphe";
        system = "nixos";
        gui = false;
        bootloader = "grub";
        virtualbox = true;
        secrets = true;
      };
    };
    trond-arne = {
      system = "x86_64-linux";
      flags = {
        username = "gipphe";
        homeDirectory = "/home/gipphe";
        system = "nixos";
        gui = true;
        cli = true;
        desktop = true;
        hyprland = false;
        homeFonts = true;
        plasma = true;
        wayland = false;
        bootloader = "efi";
        secrets = true;
        wsl = false;
        networkmanager = true;
        gaming = true;
        systemd = true;
        audio = true;
        printer = false;
        virtualbox = false;
        nvidia = false;
      };
    };
    VNB-MB-Pro = {
      system = "aarch64-darwin";
      flags = {
        username = "victor";
        homeDirectory = "/Users/victor";
        hostname = "VNB-MB-Pro";
        system = "nixos";
        gui = false;
        audio = false;
        homeFonts = false;
        systemd = false;
        desktop = false;
        secrets = true;
      };
    };
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  nixosMachines = filterAttrs (_: config: config.flags.system == "nixos") nixosConfigs;
  darwinMachines = filterAttrs (_: config: config.flags.system == "nix-darwin") nixosConfigs;
  machineOptions = nixpkgs.lib.attrsets.mapAttrs (
    hostname: config:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./flags.nix
        { gipphe.flags.hostname = nixpkgs.lib.mkDefault hostname; }
        { gipphe.flags = config.flags; }
      ];
    }
  ) nixosConfigs;
  nixosConfigurations = nixpkgs.lib.attrsets.mapAttrs (mkMachine nixpkgs.lib.nixosSystem) nixosMachines;

  darwinConfigurations = mapAttrs (
    config: mkMachine inputs.darwin.lib.darwinSystem (filterAttrs (k: _: k != "system" config))
  ) darwinMachines;

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
}
