{ util, pkgs, ... }:
util.mkProgram {
  name = "idea-community";
  hm.home.packages = [
    pkgs.jetbrains.idea-community
    (pkgs.writeShellScriptBin "idea" ''
      ${pkgs.jetbrains.idea-community}/bin/idea-community "$@" &>/dev/null &
    '')
  ];
}
