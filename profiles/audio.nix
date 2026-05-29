{ util, ... }:
util.mkProfile {
  name = "audio";
  shared.gipphe.programs = {
    mpc.enable = true;
    mpd.enable = true;
    mpris.enable = true;
    qpwgraph.enable = true;
    wiremix.enable = true;
  };
}
