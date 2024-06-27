{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.cyberduck.enable {
    home.packages = with pkgs; [ cyberduck ];
  };
}
