{ util, ... }:
util.mkProfile {
  name = "containers";
  shared.gipphe = {
    virtualisation.docker.enable = true;
    programs.lazydocker.enable = true;
  };
}
