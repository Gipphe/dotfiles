{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.machine;
in
{
  config = lib.mkIf cfg.gui {
    home.packages = with pkgs; [
      # password manager
      _1password

      # communication
      slack
      discord
    ];
  };
}
