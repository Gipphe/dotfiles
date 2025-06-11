{
  pkgs,
  lib,
  util,
  ...
}:
util.mkProgram {
  name = "filen-desktop";
  hm.config = lib.mkIf (pkgs.system == "x86_64-linux") {
    home.packages = [ pkgs.filen-desktop ];
  };
  system-darwin.homebrew.casks = [ "filen" ];
}
