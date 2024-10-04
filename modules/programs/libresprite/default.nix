{ util, pkgs, ... }:
util.mkProgram {
  name = "libresprite";
  hm.home.packages = [
    (pkgs.writeShellApplication {
      name = "libresprite";
      runtimeInputs = [ pkgs.libresprite ];
      text = ''
        libresprite "$@" &>/dev/null &
      '';
    })
  ];
}
