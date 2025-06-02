{ util, ... }:
util.mkEnvironment {
  name = "x";

  # Enable the X11 windowing system.
  system-nixos.services.xserver.enable = true;
}
