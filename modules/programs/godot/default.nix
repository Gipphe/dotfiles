{ pkgs, util, ... }:
util.mkProgram {
  name = "godot";
  homeManager = {
    home.packages = [ pkgs.godot_4-mono ];
  };
}
