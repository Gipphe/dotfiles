{ util, ... }:
util.mkProfile {
  name = "terminal-capture";
  shared.gipphe.programs = {
    asciinema-agg.enable = true;
    asciinema.enable = true;
    asciinema.onDemand = true;
    charm-freeze.enable = true;
    charm-freeze.onDemand = true;
    timg.enable = true;
    vhs.enable = true;
    vhs.onDemand = true;
  };
}
