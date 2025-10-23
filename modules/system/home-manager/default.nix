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
util.mkModule {
  hm =
    { osConfig, ... }:
    {
      # Copy config from OS to home-manager
      config.gipphe = lib.mkDefault osConfig.gipphe;
    };

  system-nixos = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager.users.${config.gipphe.username}.imports = [ ../../../root.nix ];
  };

  system-droid.home-manager = {
    config = ../../../root.nix;
  };

  system-all = {
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

        osConfig = config;
        flags = flags // {
          isHm = true;
          isSystem = false;
        };
      };
    };
  };
}
