{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.bcn.enable {
    home.packages = [ (pkgs.writeShellScriptBin "bcn" (builtins.readFile ./bcn)) ];
  };
}
