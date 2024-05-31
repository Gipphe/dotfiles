{ inputs, ... }:
{
  imports = [
    inputs.nix-index-db.hmModules.nix-index
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

  home.sessionVariables.PAGER = "less -FXR";

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
