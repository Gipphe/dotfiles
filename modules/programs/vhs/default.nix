{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.vhs;
in
util.mkProgram {
  name = "vhs";
  options.gipphe.programs.vhs.onDemand = lib.mkEnableOption "fetching vhs on demand";
  hm.home.packages = if cfg.onDemand then [ (util.mkOnDemand pkgs.vhs) ] else [ pkgs.vhs ];
}
