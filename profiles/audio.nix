{ util, ... }:
util.mkProfile {
  name = "audio";
  shared.gipphe.programs = {
    bcn.enable = true;
    # Temporarily broken
    cava.enable = false;
    mpc-cli.enable = true;
    mpd.enable = true;
    mpris.enable = true;
  };
}
