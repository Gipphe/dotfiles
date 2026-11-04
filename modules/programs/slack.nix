{ den, ... }: {
  den.aspects.programs.slack = {
    includes = [ (den.batteries.unfree [ "slack" ]) ];
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.slack ];
    };
  };
}
