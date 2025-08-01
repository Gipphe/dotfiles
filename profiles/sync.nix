{ util, ... }:
util.mkProfile {
  name = "sync";
  shared.gipphe.programs.syncthing.enable = true;
}
