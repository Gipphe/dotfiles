{ nixpkgs, self, ... }@inputs:
let
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (lib) nixosSystem;
  inherit (inputs.darwin.lib) darwinSystem;

  machines = lib.pipe ./machines [
    builtins.readDir
    (lib.filterAttrs (_: t: t == "directory"))
    builtins.attrNames
    (builtins.map (x: (import ./machines/${x}/default.nix).gipphe.host))
    lib.mergeAttrsList
  ];

  nixOnDroidConfiguration =
    {
      specialArgs,
      modules,
      ...
    }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      inherit modules;
      extraSpecialArgs = specialArgs;
    };

  nixosMachines = filterAttrs (_: c: c.machine == "nixos") machines;
  darwinMachines = filterAttrs (_: c: c.machine == "nix-darwin") machines;
  droidMachines = filterAttrs (_: c: c.machine == "nix-on-droid") machines;

  nixosFlags = {
    isNixos = true;
    isNixDarwin = false;
    isNixOnDroid = false;
    isHm = false;
    isSystem = true;
  };
  darwinFlags = {
    isNixos = false;
    isNixDarwin = true;
    isNixOnDroid = false;
    isHm = false;
    isSystem = true;
  };
  droidFlags = {
    isNixos = false;
    isNixDarwin = false;
    isNixOnDroid = true;
    isHm = false;
    isSystem = true;
  };
  nixosConfigurations = mapAttrs (mkMachine nixosFlags nixosSystem) nixosMachines;
  darwinConfigurations = mapAttrs (mkMachine darwinFlags darwinSystem) darwinMachines;
  nixOnDroidConfigurations = mapAttrs (mkMachine droidFlags nixOnDroidConfiguration) droidMachines;

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
}
