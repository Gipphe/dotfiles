{
  self,
  inputs,
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
    users.${flags.user.username}.imports = [ ../../../../default.nix ];
  };
}
