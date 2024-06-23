{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ ./options.nix ];
  config = lib.mkIf config.gipphe.programs._1password.enable {
    home.packages = with pkgs; [ _1password ];
  };
}
