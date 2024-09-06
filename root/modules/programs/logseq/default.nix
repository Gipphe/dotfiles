{
  util,
  lib,
  config,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.logseq.enable = lib.mkEnableOption "Logseq";
  hm = lib.mkIf config.gipphe.programs.logseq.enable { home.packages = [ pkgs.logseq ]; };
}
