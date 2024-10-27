{
  lib,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "godot";
  hm = lib.mkMerge [
    {
      gipphe.windows.chocolatey.programs = [ "godot" ];
    }
    (lib.mkIf (!pkgs.stdenv.isDarwin) {
      gipphe.programs.code-cursor.settings."godotTools.editorPath.godot4" = "${pkgs.godot_4}/bin/godot";
      home.packages = [
        (pkgs.writeShellScriptBin "gd" ''
          ${pkgs.godot_4}/bin/godot "$@" &>/dev/null &
        '')
      ];
    })
    (lib.mkIf pkgs.stdenv.isDarwin {
      gipphe.programs.code-cursor.settings."godotTools.editorPath.godot4" = "godot";
      home.packages = [
        (pkgs.writeShellScriptBin "gd" ''
          open -na "Godot.app" --args "$@"
        '')
      ];
    })
  ];
  system-darwin.homebrew.casks = [ "godot" ];
}
