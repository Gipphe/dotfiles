{ nixpkgs, self, ... }@inputs:
let
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (import ./util.nix { inherit lib; }) enumerateMachines;

  machines = filterAttrs (_: c: c.machine == "nix-darwin") (enumerateMachines ../machines);

  flags = {
    isNixos = false;
    isNixDarwin = true;
    isNixOnDroid = false;
    isHm = false;
    isSystem = true;
  };

  mkMachine =
    hostname: config:
    let
      util = nixpkgs.legacyPackages.${config.system}.callPackage ../util.nix { };
    in
    inputs.darwin.lib.darwinSystem {
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
        ../root.nix
        { gipphe.machines.${hostname}.enable = true; }
      ];
    };
in
{
  darwinConfigurations = mapAttrs mkMachine machines;
}
