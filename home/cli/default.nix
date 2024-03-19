{ ... }:
{
  imports = [
    ./git.nix
    ./packages.nix
    ./tools.nix
    ./fish
    ./neovim
    ./kitty
    ./tmux
    # ./run-as-service.nix
  ];
}
