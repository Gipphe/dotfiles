{ self, ... }: {
  den.aspects.programs.jdenticon-cli.homeManager = { pkgs, ... }: {
    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.jdenticon-cli ];
  };
}
