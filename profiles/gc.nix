{ util, ... }:
util.mkProfile {
  name = "gc";
  shared.gipphe.programs.nix.gc.enable = true;
}
