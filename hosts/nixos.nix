{ nixpkgs, self, ... }@inputs:
let
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (import ./util.nix { inherit lib; }) enumerateMachines;

  machines = filterAttrs (_: c: c.machine == "nixos") (enumerateMachines ../machines);

  flags = {
    isNixos = true;
    isNixOnDroid = false;
    isHm = false;
    isSystem = true;
  };

  mkMachine =
    hostname: config:
    let
      util = nixpkgs.legacyPackages.${config.system}.callPackage ../util.nix { };
    in
    lib.nixosSystem {
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
  nixosConfigurations = mapAttrs mkMachine machines;
}
