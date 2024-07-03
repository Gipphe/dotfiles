{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs._1password-gui.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [ _1password-gui ];
  };
}
