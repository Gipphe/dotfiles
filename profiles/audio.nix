{ util, ... }:
util.mkProfile "audio" {
  gipphe.programs = {
    bcn.enable = true;
    # Temporarily broken
    cava.enable = false;
    mpc-cli.enable = true;
    mpd.enable = true;
    mpris.enable = true;
  };
}
