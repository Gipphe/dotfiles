{ util, ... }:
util.mkProgram {
  name = "plasma6";

  # Enable the Plasma (KDE) Desktop Environment.
  system-nixos.services.desktopManager.plasma6.enable = true;
}
