{
  inputs,
  self,
  config,
  ...
}:
let
  flags = config.gipphe.flags;
  system = if flags.nixos then [ ./nixos ] else [ ./nix-darwin ];
in
{
  imports = [
    ../flags.nix
    {
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = {
          inherit self inputs;
        };
        users.${flags.username}.imports = [
          ./home
          ../flags.nix
          { gipphe.flags = flags; }
        ];
      };
    }
    ./common
  ] ++ system;
}
