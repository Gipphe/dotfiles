{ util, ... }:
util.mkProfile {
  name = "core";
  shared.gipphe = {
    programs.nix = {
      enable = true;
      determinate.enable = true;
      gc.enable = true;
    };
    system = {
      user.enable = true;
      xdg.enable = true;
    };
  };
}
