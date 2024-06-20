{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.mpc-cli.enable = lib.mkEnableOption "mpc-cli";
  config = lib.mkIf config.gipphe.programs.mpc-cli.enable { home.packages = with pkgs; [ mpc-cli ]; };
}
