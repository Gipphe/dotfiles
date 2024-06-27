{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs._1password.enable {
    home.packages = with pkgs; [ _1password ];
  };
}
