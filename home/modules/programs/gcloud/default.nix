{
  util,
  lib,
  config,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.gcloud.enable = lib.mkEnableOption "gcloud";
  hm = lib.mkIf config.gipphe.programs.gcloud.enable {
    home.packages = [
      (pkgs.google-cloud-sdk.withExtraComponents (
        with pkgs.google-cloud-sdk.components;
        [
          bq
          gke-gcloud-auth-plugin
        ]
      ))
    ];
  };
}
