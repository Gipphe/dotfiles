{ util, ... }:
util.mkProfile "work-wsl" {
  gipphe.programs = {
    code-cursor = {
      enable = true;
      wsl = true;
    };
  };
}
