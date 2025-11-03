{ pkgs, util, ... }:
util.mkProgram {
  name = "godot";
  hm = {
    home.packages = [
      (pkgs.writeShellScriptBin "gd" ''
        ${pkgs.godot_4-mono}/bin/godot-mono "$@" &>/dev/null &
      '')
    ];
    gipphe.windows.chocolatey.programs = [
      "godot-mono"
      "dotnet-8.0-sdk"
    ];
  };
}
