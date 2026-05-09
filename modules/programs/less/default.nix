{ util, ... }:
util.mkProgram {
  name = "less";
  home-manager = {
    programs.less.enable = true;
    home.sessionVariables.PAGER = "less -FXR";
  };
}
