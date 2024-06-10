{
  lib,
  flags,
  pkgs,
  ...
}:
{
  config = lib.mkIf (!flags.system.isNixDarwin) {
    home = {
      packages = with pkgs; [ jetbrains.idea-ultimate ];
    };
    programs.fish.shellAbbrs.idea = "idea-ultimate";
  };
}
