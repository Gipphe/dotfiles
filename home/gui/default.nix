{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.flags.gui {
    imports = [ ./filen.nix ];
    home.packages = with pkgs; [
      _1password-gui
      ledger-live-desktop
      ledger_agent
      discord
      cool-retro-term
      betterdiscord-installer
      slack
    ];
  };
}
