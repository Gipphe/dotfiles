{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.environment.theme.catppuccin.enable {
    catppuccin = {
      enable = true;
      flavor = "macchiato";
    };
  };
}
