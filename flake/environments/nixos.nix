{
  withSystem,
  self,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
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
      pkgs = withSystem config.system ({ pkgs, ... }: pkgs);
      util = inputs.flaketilities.lib.${pkgs.stdenv.hostPlatform.system};
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
        ../../root.nix
        { gipphe.hosts.${hostname}.enable = true; }
        { nixpkgs.pkgs = pkgs; }
      ];
    };
in
{
  flake.nixosConfigurations = mapAttrs mkMachine hosts;
}
