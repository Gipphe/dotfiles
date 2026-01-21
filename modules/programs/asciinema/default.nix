{
  util,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.asciinema;
in
util.mkProgram {
  name = "asciinema";
  options.gipphe.programs.asciinema.onDemand = lib.mkEnableOption "fetching asciinema on demand";
  hm.home.packages =
    if cfg.onDemand then [ (util.mkOnDemand pkgs.asciinema) ] else [ pkgs.asciinema ];
}
