{ util, ... }:
util.mkProgram {
  name = "sunshine";
  system-nixos = {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
