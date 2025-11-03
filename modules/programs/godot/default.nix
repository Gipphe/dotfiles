{ pkgs, util, ... }:
util.mkProgram {
  name = "godot";
  hm = {
    home.packages = [ pkgs.godot_4-mono ];
    gipphe.windows.chocolatey.programs = [
      "godot-mono"
      "dotnet-8.0-sdk"
    ];
  };
}
