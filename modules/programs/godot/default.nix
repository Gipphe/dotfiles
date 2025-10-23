{
  config,
  lib,
  pkgs,
  util,
  ...
}:
util.mkModule {
  options.gipphe.programs.godot.enable = lib.mkEnableOption "godot";
  hm.config = lib.mkMerge [
    {
      gipphe.programs.code-cursor.windowsSettings = {
        "godotTools.editorPath.godot4" = lib.mkDefault "godot";
        "godotTools.lsp.serverPort" = lib.mkDefault 6005;
      };
    }
    (lib.mkIf config.gipphe.programs.godot.enable (
      lib.mkMerge [
        {
          gipphe = {
            windows.chocolatey.programs = [
              "godot-mono"
              "dotnet-8.0-sdk"
            ];
            programs.code-cursor.settings."godotTools.editorPath.godot4" = "${pkgs.godot_4-mono}/bin/godot";
          };
          home.packages = [
            (pkgs.writeShellScriptBin "gd" ''
              ${pkgs.godot_4-mono}/bin/godot-mono "$@" &>/dev/null &
            '')
          ];
        }
      ]
    ))
  ];
}
