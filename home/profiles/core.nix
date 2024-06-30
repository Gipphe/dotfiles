{ util, ... }:
util.mkProfile "core" {
  gipphe.programs = {
    nix.enable = true;
  };
}
