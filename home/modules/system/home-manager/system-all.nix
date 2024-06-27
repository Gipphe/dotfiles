{
  self,
  inputs,
  config,
  flags,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup-before-nix";
    extraSpecialArgs = {
      inherit self inputs;
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
