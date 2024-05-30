{ ... }:
{
  imports = [
    ./system.nix
    ./network.nix
    ./secrets.nix
    ./nix.nix
    ./users.nix
    ./openssh.nix
    ./schizo.nix
  ];
}
