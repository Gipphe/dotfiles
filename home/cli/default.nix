{ ... }:
{
  imports = [
    ./git.nix
    ./packages.nix
    ./tools.nix
    ./fish
    ./neovim
    ./nixvim
    ./kitty
    ./tmux
    ./run-as-service.nix
  ];

  gipphe.nixvim.enable = true;
}
