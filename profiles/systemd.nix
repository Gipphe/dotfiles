{ util, ... }:
util.mkProfile {
  name = "systemd";
  shared.gipphe.programs.run-as-service.enable = true;
}
