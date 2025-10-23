{ pkgs, util, ... }:
util.mkProgram {
  name = "obsidian";
  hm.home.packages = [ pkgs.obsidian ];
}
