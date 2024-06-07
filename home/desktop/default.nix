{
  lib,
  flags,
  pkgs,
  ...
}:
lib.optionalAttrs flags.desktop {
  imports = [
    ./hyprland
    ./gaming.nix
    ./filen.nix
    ./term.nix
  ];
  home.packages = with pkgs; [
    _1password-gui
    ledger-live-desktop
    ledger_agent
    discord
    cool-retro-term
    betterdiscord-installer
    slack
    vivaldi

    xflux
    gnome.nautilus
    gnome.zenity
    gnome.gnome-tweaks
    gnome.eog
  ];
}
