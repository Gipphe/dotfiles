{ util, inputs, ... }:
util.mkModule {
  hm = {
    imports = [ inputs.nix-index-db.homeModules.nix-index ];
    programs.nix-index-database.comma.enable = true;
  };
}
