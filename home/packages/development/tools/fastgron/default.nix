{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.fastgron.enable = lib.mkEnableOption "fastgron";
  config = lib.mkIf config.gipphe.programs.fastgron.enable {
    home.packages = with pkgs; [ fastgron ];
  };
}
