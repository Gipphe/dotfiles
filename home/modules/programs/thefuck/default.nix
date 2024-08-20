{
  lib,
  config,
  util,
  ...
}:
util.mkModule {
  options.gipphe.programs.thefuck.enable = lib.mkEnableOption "thefuck";
  hm = lib.mkIf config.gipphe.programs.thefuck.enable { programs.thefuck.enable = true; };
}
