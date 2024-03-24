{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [

    # Programs
    _1password-gui
    ledger-live-desktop
    ledger_agent
    discord
    cool-retro-term
    lutris
    betterdiscord-installer

    # Utils
    dconf
    git
    catimg
    curl
    xflux

    # Misc
    cava
    neofetch
    mpc-cli
    gnome.nautilus
    gnome.zenity
    gnome.gnome-tweaks
    gnome.eog
  ];
}
