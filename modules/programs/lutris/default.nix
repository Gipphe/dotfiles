{ util, osConfig, ... }:
util.mkProgram {
  name = "lutris";
  hm = {
    programs.lutris = {
      enable = true;
      steamPackage = osConfig.programs.steam.package;
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
