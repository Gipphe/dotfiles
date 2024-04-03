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
    ./zellij
    ./run-as-service.nix
  ];

  gipphe.nixvim.enable = true;
  gipphe.neovim.enable = false;
  gipphe.programs.tmux.enable = false;
  gipphe.programs.zellij.enable = true;
}
