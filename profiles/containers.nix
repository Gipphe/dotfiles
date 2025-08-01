{ util, ... }:
util.mkProfile {
  name = "containers";
  shared.gipphe = {
    programs = {
      docker.enable = true;
      lazydocker.enable = true;
    };
  };
}
