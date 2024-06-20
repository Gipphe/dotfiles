{ lib, ... }:
{
  imports = [ ./config.nix ];
  # Handled by nix-darwin
  options.gipphe.programs.karabiner-elements.enable = lib.mkEnableOption "karabiner-elements";
}
