{ util, inputs, ... }:
util.mkModule {
  home-manager = {
    imports = [ inputs.nix-index-db.homeModules.nix-index ];
    programs.nix-index-database.comma.enable = true;
  };
}
