{ inputs, ... }:
{
  imports = [
    ./run-as-service.nix
    ./tools.nix
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
