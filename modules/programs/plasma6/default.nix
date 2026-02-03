{ util, lib, ... }:
util.mkProgram {
  name = "plasma6";

  # Enable the Plasma (KDE) Desktop Environment.
  system-nixos = {
    services = {
      auto-cpufreq.enable = lib.mkForce false;
      desktopManager.plasma6.enable = true;
    };
  };
}
