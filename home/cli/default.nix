{
  imports = [
    ./git.nix
    ./packages.nix
    ./tools.nix
    ./fish
    ./neovim
    ./nix.nix
    ./nixvim
    ./kitty.nix
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

      tide.enable = false;
      starship.enable = true;
    };
  };
}
