{
  lib,
  flags,
  pkgs,
  ...
}:
{
  imports = lib.optionals flags.gui [ ./filen.nix ];
  config = lib.mkIf flags.gui {
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
