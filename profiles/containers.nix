{ util, ... }:
util.mkProfile "containers" {
  gipphe = {
    virtualisation.docker.enable = true;
    programs.lazydocker.enable = true;
  };
}
