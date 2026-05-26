{ util, inputs, ... }:
util.mkModule {
  homeManager = {
    imports = [ inputs.nix-index-db.homeModules.nix-index ];
    programs.nix-index-database.comma.enable = true;
  };
}
