{ util, ... }:
util.mkProfile {
  name = "terminal-capture";
  shared.gipphe.programs = {
    charm-freeze.enable = true;
    charm-freeze.onDemand = true;
  };
}
