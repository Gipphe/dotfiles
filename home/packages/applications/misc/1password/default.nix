{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs._1password.enable = lib.mkEnableOption "_1password";
  config = lib.mkIf config.gipphe.programs._1password.enable {
    home.packages = with pkgs; [ _1password ];
  };
}
