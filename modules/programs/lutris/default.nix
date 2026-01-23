{ util, osConfig, ... }:
util.mkProgram {
  name = "lutris";
  hm = {
    programs.lutris = {
      enable = true;
      steamPackage = osConfig.programs.steam.package;
    };
  };
}
