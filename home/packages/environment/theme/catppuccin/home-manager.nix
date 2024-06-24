{
  inputs,
  flags,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
  config = lib.mkIf config.gipphe.environment.theme.catppuccin.enable {
    catppuccin = {
      enable = !flags.stylix.enable;
      flavor = "macchiato";
    };
  };
}
