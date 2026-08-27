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
      pkgs = import ./nixpkgs.nix {
        inherit (config) system;
        inherit inputs;
      };
      util = pkgs.callPackage ../util.nix { };
    in
    lib.nixosSystem {
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
        { nixpkgs.pkgs = pkgs; }
      ];
    };
in
{
  nixosConfigurations = mapAttrs mkMachine hosts;
}
