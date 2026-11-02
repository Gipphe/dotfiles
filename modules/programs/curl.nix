{
  den.aspects.programs.curl.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.curlFull ];
  };
}
