{ pkgs, util, ... }:
util.mkProgram {
  name = "slack";

  hm.config = {
    home.packages = with pkgs; [ slack ];
  };
}
