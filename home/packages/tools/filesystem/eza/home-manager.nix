{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.eza.enable {
    programs.eza = {
      enable = true;
      icons = true;
      git = true;
    };
  };
}
