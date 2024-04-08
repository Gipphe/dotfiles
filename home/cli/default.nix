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

  gipphe = {
    nixvim.enable = true;
    neovim.enable = false;
    programs = {
      tmux.enable = false;
      zellij.enable = true;
    };
  };
}
