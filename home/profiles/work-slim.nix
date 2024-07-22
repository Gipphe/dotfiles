{ util, ... }:
util.mkProfile "work-slim" {
  gipphe.programs = {
    dataform.enable = true;
    gcloud.enable = true;
    idea-ultimate.enable = true;
  };
}
