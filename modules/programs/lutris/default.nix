{
  util,
  osConfig,
  pkgs,
  ...
}:
util.mkProgram {
  name = "lutris";
  home-manager = {
    programs.lutris = {
      enable = true;
      steamPackage = osConfig.programs.steam.package;
      defaultWinePackage = pkgs.proton-ge-bin;
      winePackages = [ pkgs.wineWow64Packages.full ];
    };
  };
  system-nixos = {
    nixpkgs.overlays = [
      (_: prev: {
        # TODO: See https://github.com/nixos/nixpkgs/issues/513245
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
    ];
  };
}
