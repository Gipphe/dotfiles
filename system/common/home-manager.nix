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
      inherit self inputs flags;
    };
    users.${flags.user.username}.imports = [ ../../home ];
  };
}
