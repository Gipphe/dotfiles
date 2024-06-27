{ lib, ... }:
{
  options.gipphe.programs.vim.enable = lib.mkEnableOption "vim";
}
