{
  inputs,
  pkgs,
  util,
  ...
}:
let
  pkg = if pkgs.stdenv.isDarwin then inputs.brew-nix.packages.${pkgs.system}.godot else pkgs.godot_4;
in
util.mkProgram {
  name = "godot";
  hm = {
    gipphe.windows.chocolatey.programs = [ "godot" ];
    gipphe.programs.code-cursor.settings."godotTools.editorPath.godot4" = "${pkg}/bin/godot";
    home.packages = [
      (pkgs.writeShellScriptBin "godot" ''
        ${pkg}/bin/godot "$@" &>/dev/null &
      '')
    ];
  };
}
