{ util, pkgs, ... }:
util.mkProgram {
  name = "google-cloud-sdk";
  hm.home.packages = with pkgs; [
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
        kubectl
      ]
    ))
  ];
}
