{ util, ... }:
util.mkToggledModule
  [
    "environment"
    "desktop"
  ]
  {
    name = "plasma";

    # Enable the Plasma (KDE) Desktop Environment.
    system-nixos.services.desktopManager.plasma6.enable = true;
  }
