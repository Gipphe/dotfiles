{
  util,
  lib,
  config,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.dataform.enable = lib.mkEnableOption "dataform";
  hm = lib.mkIf config.gipphe.programs.dataform.enable {
    home.packages = [
      (import ./pkg {
        inherit pkgs;
        inherit (pkgs) system;
        nodejs = pkgs.nodejs_20;
      })."@dataform/cli"
    ];
  };
}
