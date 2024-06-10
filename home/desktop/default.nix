{
  lib,
  flags,
  pkgs,
  ...
}:
lib.optionalAttrs flags.desktop.enable {
  imports = [
    ./hyprland
    ./gaming.nix
    ./filen.nix
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
