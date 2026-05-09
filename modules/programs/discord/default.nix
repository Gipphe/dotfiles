{ util, ... }:
util.mkProgram {
  name = "discord";
  home-manager = {
    programs.discord = {
      enable = true;
    };
  };
}
