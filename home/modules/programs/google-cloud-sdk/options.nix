{ lib, ... }:
{
  options.gipphe.programs.google-cloud-sdk.enable = lib.mkEnableOption "google-cloud-sdk (gcloud)";
}
