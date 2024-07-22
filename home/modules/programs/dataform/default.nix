{
  util,
  lib,
  config,
  self,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.dataform.enable = lib.mkEnableOption "dataform";
  hm = lib.mkIf config.gipphe.programs.dataform.enable {
    home.packages = [ self.packages.${pkgs.system}.dataform ];
  };
}
