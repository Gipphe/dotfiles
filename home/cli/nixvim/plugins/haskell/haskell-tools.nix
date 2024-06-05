{ inputs, pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = [ inputs.haskell-tools-nvim.packages.${pkgs.system}.default ];
  };
}
