{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  options.gipphe.programs.yazi.enable = lib.mkEnableOption "yazi";
  hm = lib.mkIf config.gipphe.programs.yazi.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
