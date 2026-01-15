{ util, ... }:
util.mkProfile {
  name = "core";
  shared.gipphe = {
    programs.nix.enable = true;
    system = {
      user.enable = true;
      xdg.enable = true;
    };
  };
}
