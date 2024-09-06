{
  util,
  config,
  lib,
  ...
}:
util.mkModule {
  options.gipphe.programs.k9s.enable = lib.mkEnableOption "k9s";
  hm = lib.mkIf config.gipphe.programs.k9s.enable { programs.k9s.enable = true; };
}
