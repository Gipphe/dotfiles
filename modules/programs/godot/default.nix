{ pkgs, util, ... }:
util.mkProgram {
  name = "godot";
  home-manager = {
    home.packages = [ pkgs.godot_4-mono ];
  };
}
