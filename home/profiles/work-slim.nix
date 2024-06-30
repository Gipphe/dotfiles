{ util, ... }:
util.mkProfile "work-slim" {
  gipphe.programs = {
    idea-ultimate.enable = true;
  };
}
