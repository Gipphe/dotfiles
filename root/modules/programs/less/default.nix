{ util, ... }:
util.mkProgram {
  name = "less";
  hm = {
    programs.less.enable = true;
    home.sessionVariables.PAGER = "less -FXR";
  };
}
