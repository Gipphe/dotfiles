{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.charm-freeze;
in
util.mkProgram {
  name = "charm-freeze";
  options.gipphe.programs.charm-freeze.onDemand =
    lib.mkEnableOption "fetching charm-freeze on demand";
  hm.home.packages =
    if cfg.onDemand then [ (util.mkOnDemand pkgs.charm-freeze) ] else [ pkgs.charm-freeze ];
}
