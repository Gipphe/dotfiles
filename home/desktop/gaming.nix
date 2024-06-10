{
  lib,
  flags,
  pkgs,
  ...
}:
{
  config = lib.mkIf flags.use-case.gaming { home.packages = with pkgs; [ lutris ]; };
}
