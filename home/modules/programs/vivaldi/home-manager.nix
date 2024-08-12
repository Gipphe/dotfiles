{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.vivaldi.enable {
    home.packages = [ (lib.mkIf pkgs.stdenv.isLinux pkgs.vivaldi) ];
  };
}
