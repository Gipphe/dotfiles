{ nixpkgs, self, ... }@inputs:
let
  machines = {
    argon.system = "x86_64-linux";
    cobalt.system = "x86_64-linux";
    silicon.system = "aarch64-darwin";
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  inherit (nixpkgs.lib) nixosSystem hasSuffix;
  inherit (inputs.darwin.lib) darwinSystem;

  nixosMachines = filterAttrs (_: config: !(hasSuffix "darwin" config.system)) machines;
  darwinMachines = filterAttrs (_: config: hasSuffix "darwin" config.system) machines;

  nixosFlags = {
    isNixos = true;
    isNixDarwin = false;
    isHm = false;
    isSystem = true;
  };
  darwinFlags = {
    isNixos = false;
    isNixDarwin = true;
    isHm = false;
    isSystem = true;
  };
  nixosConfigurations = mapAttrs (mkMachine nixosFlags nixosSystem) nixosMachines;
  darwinConfigurations = mapAttrs (mkMachine darwinFlags darwinSystem) darwinMachines;

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
}
