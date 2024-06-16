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
    ./tmux
    ./tools.nix
    ./zellij
  ];

  home.sessionVariables.PAGER = "less -FXR";

  gipphe = {
    programs = {
      nixvim.enable = false;
      neovim.enable = true;

      tmux.enable = false;
      zellij.enable = true;

      tide.enable = false;
      starship.enable = true;
    };
  };
}
