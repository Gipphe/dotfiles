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

    titanium.system = "x86_64-linux";
    titanium.machine = "windows";
    lithium.system = "x86_64-linux";
    lithium.machine = "windows";
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (inputs.darwin.lib) darwinSystem;

  nixOnDroidConfiguration =
    cfg:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = nixpkgs.legacyPackages."aarch64-linux";
    }
    // cfg;

  windowsConfiguration = inputs.windows-configuration.lib."x86_64-linux".mkWindowsConfiguration;

  nixosMachines = filterAttrs (_: c: c.machine == "nixos") machines;
  darwinMachines = filterAttrs (_: c: c.machine == "nix-darwin") machines;
  droidMachines = filterAttrs (_: c: c.machine == "nix-on-droid") machines;
  windowsMachines = filterAttrs (_: c: c.machine == "windows") machines;

  baseFlags = {
    isNixos = false;
    isNixDarwin = false;
    isNixOnDroid = false;
    isHm = false;
    isSystem = false;
  };

  nixosFlags = baseFlags // {
    isNixos = true;
    isSystem = true;
  };
  darwinFlags = baseFlags // {
    isNixDarwin = true;
    isSystem = true;
  };
  droidFlags = baseFlags // {
    isNixOnDroid = true;
    isSystem = true;
  };
  windowsFlags = baseFlags // {
    isWindows = true;
  };
  nixosConfigurations = mapAttrs (mkMachine nixosFlags nixosSystem) nixosMachines;
  darwinConfigurations = mapAttrs (mkMachine darwinFlags darwinSystem) darwinMachines;
  nixOnDroidConfigurations = mapAttrs (mkMachine droidFlags nixOnDroidConfiguration) droidMachines;
  windowsConfigurations = mapAttrs (mkMachine windowsFlags windowsConfiguration) windowsMachines;

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
