{ util, ... }:
util.mkProfile "audio" {
  gipphe.programs = {
    bcn.enable = true;
    cava.enable = true;
    mpc-cli.enable = true;
  };
}
