{ util, ... }:
util.mkProgram {
  name = "mako";
  hm.services.mako = {
    enable = true;
    settings = {
      # font = "Fira Sans Semibold";
      border-radius = 8;
      padding = 8;
      border-size = 5;
      default-timeout = 4000;
    };
  };
}
