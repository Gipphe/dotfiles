{ util, ... }:
util.mkProfile "sync" {
  gipphe.programs.syncthing.enable = true;
}
