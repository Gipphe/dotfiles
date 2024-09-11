{ util, ... }:
util.mkProfile "work-slim" {
  gipphe.programs = {
    gcloud.enable = true;
    idea-ultimate.enable = true;
    kubectl.enable = true;
    kubectx.enable = true;
  };
}
