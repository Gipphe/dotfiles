{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.cyberduck.enable = lib.mkEnableOption "cyberduck";
  config = lib.mkIf config.gipphe.programs.cyberduck.enable {
    home.packages = with pkgs; [ cyberduck ];
  };
}
