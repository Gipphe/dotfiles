{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    ledger-live-desktop
    ledger_agent
    pulseaudio
    dconf
  ];
}
