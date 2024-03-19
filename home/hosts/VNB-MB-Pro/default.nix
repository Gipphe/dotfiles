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
    reattach-to-user-namespace
    alt-tab-macos
    cyberduck
    (import ../../home/packages/filen { inherit pkgs system; })
  ];

  protrams.barrier.client = {
    enable = true;
    enableDragDrop = true;
    machine.name = "VNB-MB-Pro";
  };
}
