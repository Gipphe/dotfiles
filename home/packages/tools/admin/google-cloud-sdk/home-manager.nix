{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.google-cloud-sdk.enable {
    home.packages = with pkgs; [
      (google-cloud-sdk.withExtraComponents (
        with google-cloud-sdk.components;
        [
          gke-gcloud-auth-plugin
          kubectl
        ]
      ))
    ];
  };
}
