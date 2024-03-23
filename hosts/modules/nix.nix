{ ... }:
{
  # Enable flakes and nix-command features to use Nix in the modern age
  nix.settings.extra-experimental-features = [
    "flakes"
    "nix-command"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
