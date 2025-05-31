{ util, ... }:
util.mkEnvironment {
  name = "x";

  # Enable the X11 windowing system.
  system-nixos.xserver.enable = true;
}
