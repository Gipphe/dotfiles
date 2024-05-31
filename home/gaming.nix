{
  lib,
  flags,
  pkgs,
  ...
}:
{
  config = lib.mkIf flags.gaming { home.packages = with pkgs; [ lutris ]; };
}
