{ util, ... }:
util.mkProfile {
  name = "strise-wsl";
  shared.gipphe.programs = {
    code-cursor = {
      enable = true;
      wsl = true;
    };
  };
}
