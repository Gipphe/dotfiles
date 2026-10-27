{ util, ... }:
util.mkProgram {
  name = "neomutt";
  homeManager = {
    programs.neomutt = {
      enable = true;
      vimKeys = true;
    };
  };
}
