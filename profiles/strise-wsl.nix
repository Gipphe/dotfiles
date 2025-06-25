{ util, ... }:
util.mkProfile "strise-wsl" {
  gipphe.programs = {
    code-cursor = {
      enable = true;
      wsl = true;
    };
  };
}
