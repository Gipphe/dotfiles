{
  inputs,
  flags,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
  options.gipphe.environment.theme.catppuccin.enable = lib.mkEnableOption "catppuccin theme";
  config = lib.mkIf config.gipphe.environment.theme.catppuccin.enable {
    catppuccin = {
      enable = !flags.stylix.enable;
      flavor = "macchiato";
    };
  };
}
