{ lib, config, ... }:
{
  options.gipphe.programs.eza.enable = lib.mkEnableOption "eza";
  config = lib.mkIf config.gipphe.programs.eza.enable {
    programs.eza = {
      enable = true;
      icons = true;
      git = true;
    };
  };
}
