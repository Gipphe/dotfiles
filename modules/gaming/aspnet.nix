{ util, pkgs, ... }:
util.mkGaming {
  # Used by the local server for SPT (single-player Tarkov).
  name = "aspnet";
  nixos = {
    environment.systemPackages = [ pkgs.dotnetCorePackages.aspnetcore_9_0-bin ];
  };
}
