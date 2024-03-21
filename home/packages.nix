{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    _1password-gui
    ledger-live-desktop
    ledger_agent
    pulseaudio
    dconf
  ];
}
