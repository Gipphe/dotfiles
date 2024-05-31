{
  inputs,
  self,
  config,
  flags,
  ...
}:
let
  system = if flags.nixos then [ ./nixos ] else [ ./nix-darwin ];
in
#system = [ ./nixos ];
{
  imports = [
    # {
    #   home-manager = {
    #     useUserPackages = true;
    #     useGlobalPkgs = true;
    #     extraSpecialArgs = {
    #       inherit self inputs;
    #     };
    #     users.${flags.username}.imports = [
    #       ./home
    #       ../flags.nix
    #       { gipphe.flags = flags; }
    #     ];
    #   };
    # }
    # ./common
  ] ++ system;
}
