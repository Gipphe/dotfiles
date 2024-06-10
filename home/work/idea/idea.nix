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
        packages = with pkgs; [ jetbrains.idea-ultimate ];
      };
      programs.fish.shellAbbrs.idea = "idea-ultimate";
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
