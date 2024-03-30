{ ... }:
{
  programs.nixvim.plugins.navic = {
    enable = true;
    separator = " ";
    highlight = true;
    depthLimit = 5;
    lazyUpdateContext = true;
  };
}
