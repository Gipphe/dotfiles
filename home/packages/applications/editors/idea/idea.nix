{
  inputs,
  lib,
  flags,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.idea-ultimate;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf (!flags.system.isNixDarwin) {
        home = {
          packages = with pkgs; [
            jetbrains.idea-ultimate
            (writeShellScriptBin "idea" ''
              ${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate "$@" &>/dev/null &
            '')
          ];
        };
      })

      (lib.mkIf flags.system.isNixDarwin {
        home.packages = [
          # (pkgs.writeShellScriptBin "idea" ''
          #   open -na "IntelliJ IDEA.app" --args "$@"
          # '')
          inputs.brew-nix.packages.${pkgs.system}.intellij-idea
        ];
      })
    ]
  );
}
