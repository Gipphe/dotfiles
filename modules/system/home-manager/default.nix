{
  self,
  inputs,
  config,
  util,
  lib,
  flags,
  hostname,
  ...
}:
let
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup-before-nix";
    extraSpecialArgs = {
      inherit
        self
        inputs
        util
        hostname
        ;
      environment = "homeManager";

      osConfig = config;
      flags = flags // {
        isHomeManager = true;
        isSystem = false;
      };
    };
  };
in
util.mkModule {
  homeManager =
    { osConfig, ... }:
    {
      # Copy config from OS to home-manager
      config.gipphe = lib.mkDefault osConfig.gipphe;
    };

  nixos = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = lib.mkMerge [
      home-manager
      { users.${config.gipphe.username}.imports = [ ../../../root.nix ]; }
    ];
  };

  nixOnDroid = {
    home-manager = lib.mkMerge [
      home-manager
      { config = ../../../root.nix; }
    ];
  };
}
