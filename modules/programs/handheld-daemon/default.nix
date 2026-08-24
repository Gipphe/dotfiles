{ util, ... }:
util.mkProgram {
  name = "handheld-daemon";
  nixos = {
    services.handheld-daemon.enable = true;
  };
}
