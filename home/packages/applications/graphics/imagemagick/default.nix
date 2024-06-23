{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ ./options.nix ];
  config = lib.mkIf config.gipphe.programs.imagemagick.enable {
    home.packages = with pkgs; [ imagemagick ];
  };
}
