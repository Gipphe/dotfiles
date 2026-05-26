{ util, ... }:
util.mkProgram {
  name = "sunshine";
  nixos = {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
