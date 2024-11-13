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
          gipphe.windows.chocolatey.programs = [
            "godot-mono"
            "dotnet-8.0-sdk"
          ];
        }
        (lib.mkIf (!pkgs.stdenv.isDarwin) {
          gipphe.programs.code-cursor.settings."godotTools.editorPath.godot4" = "${pkgs.godot_4-mono}/bin/godot";
          home.packages = [
            (pkgs.writeShellScriptBin "gd" ''
              ${pkgs.godot_4-mono}/bin/godot-mono "$@" &>/dev/null &
            '')
          ];
        })
        (lib.mkIf pkgs.stdenv.isDarwin {
          gipphe.programs.code-cursor.settings = {
            "godotTools.editorPath.godot4" = "godot-mono";
            "godotTools.lsp.serverPort" = 6005;
          };

          home.packages = [
            (pkgs.writeShellScriptBin "gd" ''
              open -na "godot_mono.app" --args "$@"
            '')
          ];
        })
      ]
    ))
  ];
  system-darwin = lib.mkIf config.gipphe.programs.godot.enable {
    homebrew.casks = [ "godot-mono" ];
  };
}
