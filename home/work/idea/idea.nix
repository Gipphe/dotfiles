{
  lib,
  flags,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
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
        (pkgs.writeShellScriptBin "idea" ''
          open -na "IntelliJ IDEA.app" --args "$@"
        '')
      ];
    })
  ];
}
