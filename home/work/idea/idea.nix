{
  lib,
  flags,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; lib.optionals (!flags.system.isNixDarwin) [ jetbrains.idea-ultimate ];
  };
  programs.fish.shellAbbrs.idea = "idea-ultimate";
}
