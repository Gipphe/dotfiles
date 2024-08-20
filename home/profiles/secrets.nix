{ util, ... }:
util.mkProfile "secrets" {
  gipphe = {
    programs.ssh.enable = true;
    environment.secrets.enable = true;
  };
}
