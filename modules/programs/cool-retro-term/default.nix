{ pkgs, util, ... }:
util.mkProgram {
  name = "cool-retro-term";
  hm.home.packages = [
    pkgs.cool-retro-term
  ];
}
