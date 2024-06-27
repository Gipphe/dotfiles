{ lib, ... }:
{
  options.gipphe.programs.neovim.enable = lib.mkEnableOption "neovim";
}
