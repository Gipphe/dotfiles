{
  self,
  inputs,
  config,
  flags,
  utils,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup-before-nix";
    extraSpecialArgs = {
      inherit self inputs utils;
      osConfig = config;
      flags = flags // {
        isNixos = false;
        isNixDarwin = false;
        isHm = true;
        isSystem = false;
      };
    };
    users.${config.gipphe.username}.imports = [ ../../../default.nix ];
  };
}
