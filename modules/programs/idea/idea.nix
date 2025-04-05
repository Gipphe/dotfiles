{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
{
  config = lib.mkIf config.gipphe.programs.idea-ultimate.enable (
    lib.mkMerge [
      (lib.mkIf hostPlatform.isLinux {
        home = {
          packages = with pkgs; [
            jetbrains.idea-ultimate
            (writeShellScriptBin "idea" ''
              ${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate "$@" &>/dev/null &
            '')
          ];
        };
      })

      (lib.mkIf hostPlatform.isDarwin {
        home.packages = [
          (pkgs.writeShellScriptBin "idea" ''
            open -na "IntelliJ IDEA.app" --args "$@"
          '')
          inputs.brew-nix.packages.${pkgs.system}.intellij-idea
        ];
      })
    ]
  );
}
