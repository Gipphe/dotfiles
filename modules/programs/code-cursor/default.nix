{
  util,
  pkgs,
  lib,
  ...
}:
util.mkProgram {
  name = "code-cursor";
  hm.home = {
    file."Library/Application\ Support/Cursor/User/settings.json".source = lib.mkIf pkgs.stdenv.isDarwin ./config.json;
    xdg.configFile."Cursor/User/settings.json".source = lib.mkIf pkgs.stdenv.isLinux ./config.json;
    packages = lib.mkIf pkgs.stdenv.isLinux [
      (pkgs.writeShellScriptBin "cursor" ''
        ${pkgs.code-cursor}/bin/cursor "$@" &>/dev/null &
      '')
    ];
  };
  system-darwin.homebrew.casks = [ "cursor" ];
}
