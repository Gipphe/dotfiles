{ inputs, ... }: {
  den.aspects.programs.nix-index.homeManager = { lib, pkgs, ... }: {
    imports = [ inputs.nix-index-db.homeModules.nix-index ];
    options.gipphe.programs.nix-index.comma.package = lib.mkPackageOption pkgs "comma" { } // {
      default = (import "${inputs.nix-index-db}" { inherit pkgs; }).comma-with-db;
    };
    config = {
      programs.nix-index = {
        enableBashIntegration = false;
        enableZshIntegration = false;
        enableFishIntegration = false;
      };
      programs.nix-index-database.comma.enable = true;
    };
  };
}
