{ lib, ... }:
{
  options.gipphe.environment.secrets = {
    enable = lib.mkEnableOption "secret management with agenix";
    importSecrets = lib.mkEnableOption "import secrets";
  };
}
