{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.mpc-cli.enable { home.packages = with pkgs; [ mpc-cli ]; };
}
