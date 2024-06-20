{ lib, ... }:
{
  # Handled by nix-darwin in ./nix-darwin.nix
  options.gipphe.programs.logi-options-plus.enable = lib.mkEnableOption "logi-options-plus";
}
