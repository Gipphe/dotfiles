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
      imports = lib.optional flags.isNixDarwin inputs.mac-app-util.homeManagerModules.default;
      # Copy config from OS to home-manager
      config.gipphe = osConfig.gipphe;
    };

  system-darwin.imports = [ inputs.home-manager.darwinModules.home-manager ];
  system-nixos.imports = [ inputs.home-manager.nixosModules.home-manager ];

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
          isNixos = false;
          isNixDarwin = false;
          isHm = true;
          isSystem = false;
        };
      };
      users.${config.gipphe.username}.imports = [ ../../../root.nix ];
    };
  };
}
