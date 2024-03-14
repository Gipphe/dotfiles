{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "openvpn-connect"
      "notion"
      "logi-options-plus"
      "barrier"
    ];
  };
  home.packages = with pkgs; [
    kubectx
    (google-cloud-sdk.withExtraComponents {
      components = [
        "gke-cloud-auth-plugin"
        "gcloud-crc32c"
      ];
    })
    jetbrains.idea-ultimate
  ];
}
