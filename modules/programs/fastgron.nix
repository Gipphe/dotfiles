{
  den.aspects.programs.fastgron = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.fastgron ];
    };
    nushell-abbrs.gron = "fastgron";
  };
}
