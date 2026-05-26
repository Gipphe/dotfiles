{ util, ... }:
util.mkProgram {
  name = "less";
  homeManager = {
    programs.less.enable = true;
    home.sessionVariables.PAGER = "less -FXR";
  };
}
