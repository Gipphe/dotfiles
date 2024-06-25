{ lib, ... }:
{
  options.gipphe.environment.secrets = {
    enable = lib.mkEnable "secret management with agenix";
    importSecrets = lib.mkEnableOption "import secrets";
  };
}
