{ util, ... }:
util.mkProfile {
  name = "secrets";
  shared.gipphe = {
    programs.ssh.enable = true;
    environment.secrets.enable = true;
  };
}
