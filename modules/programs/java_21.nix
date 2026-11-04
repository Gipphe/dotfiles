{
  den.aspects.programs.java_21.homeManager =
    { pkgs, ... }:
    let
      pkg = pkgs.jdk;
    in
    {
      home = {
        packages = [ pkg ];
        sessionVariables.JAVA_HOME = "${pkg}";
      };
    };
}
