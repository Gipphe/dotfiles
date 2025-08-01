{ util, ... }:
util.mkProfile {
  name = "init-secrets";
  shared.gipphe.environment.secrets.enable = true;
}
