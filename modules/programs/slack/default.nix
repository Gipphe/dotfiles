{ pkgs, util, ... }:
util.mkProgram {
  name = "slack";

  homeManager.config = {
    home.packages = [ pkgs.slack ];
  };
}
