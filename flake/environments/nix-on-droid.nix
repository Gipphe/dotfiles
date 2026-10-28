{
  withSystem,
  self,
  inputs,
  ...
}:
let
  nixpkgs = inputs.nixpkgs-last-working-for-nix-on-droid;
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  util = import ./util.nix { inherit lib; };

  hosts = filterAttrs (_: c: c.machine == "nix-on-droid") util.hosts;

  flags = {
    isNixos = false;
    isNixOnDroid = true;
    isHomeManager = false;
    isSystem = true;
  };

  mkMachine =
    hostname: config:
    let
      pkgs = withSystem config.system ({ pkgs, ... }: pkgs);
      util = inputs.flaketilities.lib.${pkgs.stdenv.hostPlatform.system};
    in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit
          inputs
          self
          hostname
          flags
          util
          ;
        environment = "nixOnDroid";
      };
      modules = [
        ../../root.nix
        { gipphe.hosts.${hostname}.enable = true; }
      ];
    };
in
{
  flake.nixOnDroidConfigurations = mapAttrs mkMachine hosts;
}
