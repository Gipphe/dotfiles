{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.fastgron.enable {
    home.packages = with pkgs; [ fastgron ];
  };
}
