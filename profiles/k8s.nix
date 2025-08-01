{ util, ... }:
util.mkProfile {
  name = "k8s";
  shared.gipphe.programs.k9s.enable = true;
}
