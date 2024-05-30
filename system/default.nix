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
    {
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = {
          inherit (flags) username homeDirectory;
          inherit self inputs;
        };
        users.${flags.username}.imports = [
          inputs.catppuccin.homeManagerModules.catppuccin
          ./home/base.nix
          ./home/hosts/VNB-MB-Pro
        ];
      };
    }
    ./common
  ] ++ system;
}
