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
    extraSpecialArgs = {
      inherit self inputs flags;
    };
    users.${flags.user.username}.imports = [ ../../home ];
  };
}
