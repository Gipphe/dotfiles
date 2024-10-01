{ util, ... }:
util.mkProfile "work-slim" {
  gipphe.programs = {
    code-cursor.enable = true;
    google-cloud-sdk.enable = true;
    idea-ultimate.enable = true;
    kubectl.enable = true;
    kubectx.enable = true;
  };
}
