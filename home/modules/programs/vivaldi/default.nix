{ lib, flags, ... }:
{
  imports =
    [ ./options.nix ]
    ++ lib.optional flags.isHm ./home-manager.nix ++ lib.optional flags.isNixDarwin ./system-darwin.nix;
}
