{ util, ... }:
util.mkProfile {
  name = "vm-host";
  shared.gipphe.programs.qemu.enable = true;
}
