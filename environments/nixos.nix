{ nixpkgs, self, ... }@inputs:
let
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  util = import ./util.nix { inherit lib; };

  machines = filterAttrs (_: c: c.machine == "nixos") util.machines;

  flags = {
    isNixos = true;
    isNixOnDroid = false;
    isHomeManager = false;
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
        environment = "nixos";
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
