{ lib, ... }:
{
  options.gipphe.programs.mpc-cli.enable = lib.mkEnableOption "mpc-cli";
}
