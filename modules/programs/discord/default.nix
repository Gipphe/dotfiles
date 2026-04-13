{ util, ... }:
util.mkProgram {
  name = "discord";
  hm = {
    programs.discord = {
      enable = true;
    };
  };
}
