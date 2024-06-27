{ lib, flags, ... }:
{
  imports = [ ./options.nix ] ++ lib.optional flags.isHm ./home-manager;
}
