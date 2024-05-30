{
  imports = [
    ./fish
    ./git.nix
    ./neovim
    ./nixvim
    ./packages.nix
    ./run-as-service.nix
    ./term.nix
    ./tmux
    ./tools.nix
    ./zellij
  ];

  gipphe = {
    programs = {
      nixvim.enable = true;
      neovim.enable = false;

      tmux.enable = false;
      zellij.enable = true;

      tide.enable = false;
      starship.enable = true;
    };
  };
}
