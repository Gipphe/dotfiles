{ nixpkgs, self, ... }@inputs:
let
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  util = import ./util.nix { inherit lib; };

  hosts = filterAttrs (_: c: c.machine == "nixos") util.hosts;

  flags = {
    isNixos = true;
    isNixOnDroid = false;
    isHomeManager = false;
    isSystem = true;
  };

  mkMachine =
    hostname: config:
    let
      util = nixpkgs.legacyPackages.${config.system}.callPackage ../util.nix {
        # TODO: Remove once 0.115.1 is in nixos-unstable.
        inherit (self.packages.${config.system}) nushell;
      };
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
        { gipphe.hosts.${hostname}.enable = true; }
      ];
    };
in
{
  nixosConfigurations = mapAttrs mkMachine hosts;
}
