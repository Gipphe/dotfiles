{ util, ... }:
util.mkProfile "secrets" {
  gipphe.environment.secrets = {
    enable = true;
    importSecrets = true;
  };
}
