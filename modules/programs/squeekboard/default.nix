{ util, pkgs, ... }:
util.mkProgram {
  name = "squeekboard";
  homeManager = {
    home.packages = [ pkgs.squeekboard ];
    # TODO: add button to noctalia to bring up the keyboard.
    # Command to show the keyboard:
    # busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
  };
}
