{
  lib,
  config,
  pkgs,
  flags,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs._1password-gui.enable && flags.system.isNixos) {
    home.packages = with pkgs; [ _1password-gui ];
  };
}
