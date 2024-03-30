{ ... }:
{
  programs.nixvim.plugins.vim-matchup = {
    enable = true;
    treesitterIntegration = {
      enable = true;
    };
  };
}
