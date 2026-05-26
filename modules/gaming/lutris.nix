{
  inputs,
  util,
  pkgs,
  osConfig,
  ...
}:
util.mkGaming {
  name = "lutris";
  homeManager = {
    programs.lutris = {
      enable = true;
      package = pkgs.lutris.override {
        extraPkgs = pkgs: [
          inputs.nix-gaming-edge.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v3
          pkgs.proton-ge-bin
        ];
      };
      steamPackage = osConfig.programs.steam.package;
      defaultWinePackage = pkgs.proton-ge-bin;
      winePackages = [ pkgs.wineWow64Packages.full ];
    };
    home.packages = [ pkgs.winePackages.waylandFull ];
  };
  nixos = {
    nixpkgs.overlays = [
      (_: prev: {
        # TODO: See https://github.com/nixos/nixpkgs/issues/513245
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
    ];
    # Required for Windows-based Epic Games store
    hardware.graphics.enable32Bit = true;
  };
}
