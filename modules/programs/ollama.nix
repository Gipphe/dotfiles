{
  den.aspects.programs.ollama.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.ollama ];
  };
}
