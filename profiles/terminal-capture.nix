{ util, ... }:
util.mkProfile {
  name = "terminal-capture";
  shared.gipphe.programs = {
    asciinema-agg.enable = true;
    asciinema.enable = true;
    charm-freeze.enable = true;
    timg.enable = true;
    vhs.enable = true;
  };
}
