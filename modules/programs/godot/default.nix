{
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "godot";
  hm = {
    home.packages = [ pkgs.godot_4 ];
    gipphe.windows.chocolatey.programs = [ "godot" ];
  };
}
