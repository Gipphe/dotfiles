{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.bcn.enable = lib.mkEnableOption "bcn";
  config = lib.mkIf config.gipphe.programs.bcn.enable {
    home.packages = [ (pkgs.writeShellScriptBin "bcn" (builtins.readFile ./bcn)) ];
  };
}
