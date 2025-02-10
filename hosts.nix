{ nixpkgs, self, ... }@inputs:
let
  machines = {
    argon.system = "x86_64-linux";
    argon.machine = "nixos";
    cobalt.system = "x86_64-linux";
    cobalt.machine = "nixos";
    silicon.system = "aarch64-darwin";
    silicon.machine = "nix-darwin";
    helium.system = "aarch64-linux";
    helium.machine = "nix-on-droid";
    titanium.system = "x86_64-nt";
    titanium.machine = "windows";
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (inputs.darwin.lib) darwinSystem;
  inherit (import ./windows-system) windowsSystem;

  nixOnDroidConfiguration =
    cfg:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = nixpkgs.legacyPackages."aarch64-linux";
    }
    // cfg;

  nixosMachines = filterAttrs (_: c: c.machine == "nixos") machines;
  darwinMachines = filterAttrs (_: c: c.machine == "nix-darwin") machines;
  droidMachines = filterAttrs (_: c: c.machine == "nix-on-droid") machines;
  windowsMachines = filterAttrs (_: c: c.machine == "windows") machines;

  nixosFlags = {
    isNixos = true;
    isNixDarwin = false;
    isNixOnDroid = false;
    isWindows = false;
    isHm = false;
    isSystem = true;
  };
  darwinFlags = {
    isNixos = false;
    isNixDarwin = true;
    isNixOnDroid = false;
    isWindows = false;
    isHm = false;
    isSystem = true;
  };
  droidFlags = {
    isNixos = false;
    isNixDarwin = false;
    isNixOnDroid = true;
    isWindows = false;
    isHm = false;
    isSystem = true;
  };
  windowsFlags = {
    isNixos = false;
    isNixDarwin = false;
    isNixOnDroid = false;
    isWindows = true;
    isHm = false;
    isSystem = true;
  };
  nixosConfigurations = mapAttrs (mkMachine nixosFlags nixosSystem) nixosMachines;
  darwinConfigurations = mapAttrs (mkMachine darwinFlags darwinSystem) darwinMachines;
  nixOnDroidConfigurations = mapAttrs (mkMachine droidFlags nixOnDroidConfiguration) droidMachines;
  windowsConfigurations = mapAttrs (mkMachine windowsFlags windowsSystem) windowsMachines;

  mkMachine =
    flags: mkSystem: hostname: config:
    let
      util = nixpkgs.legacyPackages.${config.system}.callPackage ./util.nix { };
    in
    mkSystem {
      inherit (config) system;
      specialArgs = {
        inherit
          inputs
          self
          hostname
          flags
          util
          ;
      };
      modules = [
        ./root.nix
        { gipphe.machines.${hostname}.enable = true; }
      ];
    };
in
{
  inherit nixosConfigurations;
  inherit darwinConfigurations;
  inherit nixOnDroidConfigurations;
  inherit windowsConfigurations;
}
