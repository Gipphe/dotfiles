{ util, pkgs, ... }:
util.mkProgram {
  name = "idea-community";
  homeManager.home.packages = [
    pkgs.jetbrains.idea-community
    (pkgs.writeShellScriptBin "idea" ''
      ${pkgs.jetbrains.idea-community}/bin/idea-community "$@" &>/dev/null &
    '')
  ];
}
