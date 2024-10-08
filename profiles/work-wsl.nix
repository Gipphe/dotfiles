{ util, ... }:
util.mkProfile "work-wsl" {
  gipphe.programs = {
    wsl-cursor.enable = true;
  };
}
