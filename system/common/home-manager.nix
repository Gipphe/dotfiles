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
    users.${flags.username}.imports = [ ../../home ];
  };
}
