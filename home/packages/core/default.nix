{ lib, flags, ... }:
{
  imports = [
    ./xdg.nix
    ./home.nix
    ./darwin.nix
  ] ++ lib.optional flags.isNixDarwin ./system-darwin.nix;
}
