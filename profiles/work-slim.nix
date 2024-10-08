{ util, ... }:
util.mkProfile "work-slim" {
  gipphe.programs = {
    google-cloud-sdk.enable = true;
    idea-ultimate.enable = true;
    kubectl.enable = true;
    kubectx.enable = true;
  };
}
