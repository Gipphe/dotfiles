{ util, ... }:
util.mkSystem {
  name = "camera";
  nixos = {
    boot.kernelModules = [ "uvcvideo" ];
  };
}
