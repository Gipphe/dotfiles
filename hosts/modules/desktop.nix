{ pkgs, ... }:
{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the Plasma (KDE) Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
  services.dbus.packages = [ pkgs.gcr ];
}
