{
  inputs,
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
      gipphe.programs.code-cursor.settings."godotTools.editorPath.godot4" = "godot";
    }
    (lib.mkIf (!pkgs.stdenv.isDarwin) {
      home.packages = [ pkgs.godot_4 ];
    })
    (lib.mkIf pkgs.stdenv.isDarwin {
      home.packages = [ inputs.brew-nix.packages.${pkgs.system}.godot ];
    })
  ];
}
