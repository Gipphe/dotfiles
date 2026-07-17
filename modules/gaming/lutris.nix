{
  util,
  pkgs,
  osConfig,
  ...
}:
let
  dotnet = pkgs.dotnetCorePackages.aspnetcore_9_0-bin;
in
util.mkGaming {
  name = "lutris";
  homeManager = {
    programs.lutris = {
      enable = true;
      package = pkgs.lutris.override {
        extraPkgs = pkgs: [
          pkgs.proton-ge-bin
          dotnet # Needed for SPT
        ];
      };
      steamPackage = osConfig.programs.steam.package;
      defaultWinePackage = pkgs.proton-ge-bin;
      winePackages = [ pkgs.wineWow64Packages.full ];
      protonPackages = [ pkgs.proton-ge-bin ];
    };
    home.packages = [ pkgs.wineWow64Packages.waylandFull ];
    home.sessionVariables.DOTNET_ROOT = "${dotnet}/share/dotnet";
  };
  nixos = {
    # Required for Windows-based Epic Games store
    hardware.graphics.enable32Bit = true;
  };
}
