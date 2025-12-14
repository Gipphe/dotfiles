{ util, ... }:
util.mkSystem {
  name = "camera";
  system-nixos = {
    boot.kernelModules = [ "uvcvideo" ];
  };
}
