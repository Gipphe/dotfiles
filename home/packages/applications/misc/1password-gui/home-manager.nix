{
  lib,
  config,
  pkgs,
  flags,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs._1password-gui.enable && flags.isNixos) {
    home.packages = with pkgs; [ _1password-gui ];
  };
}
