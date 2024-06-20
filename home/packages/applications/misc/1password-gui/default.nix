{
  lib,
  config,
  pkgs,
  flags,
  ...
}:
{
  options.gipphe.programs._1password-gui.enable = lib.mkEnableOption "_1password-gui";
  config = lib.mkIf (config.gipphe.programs._1password-gui.enable && flags.system.isNixos) {
    home.packages = with pkgs; [ _1password-gui ];
  };
}
