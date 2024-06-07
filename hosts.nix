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
        gui = true;
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
        system = "nix-darwin";
        gui = false;
        audio = false;
        homeFonts = false;
        systemd = false;
        desktop = false;
        secrets = true;
        wsl = false;
      };
    };
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (inputs.darwin.lib) darwinSystem;
  nixosMachines = filterAttrs (_: config: config.flags.system == "nixos") nixosConfigs;
  darwinMachines = filterAttrs (_: config: config.flags.system == "nix-darwin") nixosConfigs;
  machineOptions = mapAttrs (
    hostname: config:
    nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./flags.nix
        { gipphe.flags.hostname = nixpkgs.lib.mkDefault hostname; }
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
