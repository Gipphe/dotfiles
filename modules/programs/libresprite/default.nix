{ util, pkgs, ... }:
let
  pkg = pkgs.writeShellApplication {
    name = "libresprite";
    runtimeInputs = [ pkgs.libresprite ];
    text = ''
      libresprite "$@" &>/dev/null &
    '';
  };
in
util.mkProgram {
  name = "libresprite";
  hm.home.packages = [ pkg ];
}
