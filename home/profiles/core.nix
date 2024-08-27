{ util, ... }:
util.mkProfile "core" {
  gipphe = {
    programs.nix.enable = true;
    system.user.enable = true;
  };
}
