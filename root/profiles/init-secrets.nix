{ util, ... }: util.mkProfile "init-secrets" { gipphe.environment.secrets.enable = true; }
