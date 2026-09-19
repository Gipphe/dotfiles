{
  self,
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "headset-battery-indicator";
  homeManager.home.packages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.headset-battery-indicator
  ];
  nixos = {
    environment.systemPackages = [ pkgs.headsetcontrol ];
  };
}
