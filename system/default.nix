{
  inputs,
  lib,
  self,
  flags,
  ...
}:
{
  imports =
    [
      inputs.home-manager.nixosModules.default
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = {
            inherit self inputs flags;
          };
          users.${flags.username}.imports = [ ../home ];
        };
      }
      ./common
    ]
    ++ lib.optionals (flags.system == "nixos") [ ./nixos ]
    ++ lib.optionals (flags.system == "nix-darwin") [ ./nix-darwin ];
}
