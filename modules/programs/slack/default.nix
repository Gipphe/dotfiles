{ pkgs, util, ... }:
util.mkProgram {
  name = "slack";

  home-manager.config = {
    home.packages = [ pkgs.slack ];
  };
}
