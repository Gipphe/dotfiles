{
  den.aspects.programs.forgejo-cli.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.forgejo-cli ];
  };
}
