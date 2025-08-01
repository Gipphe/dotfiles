{ util, ... }:
util.mkProfile {
  name = "kvm";
  shared.gipphe.programs.barrier.enable = true;
}
