{
  den.aspects.programs.libresprite.homeManager =
    { pkgs, ... }:
    let
      pkg = pkgs.writeShellApplication {
        name = "libresprite";
        runtimeInputs = [ pkgs.libresprite ];
        text = ''
          libresprite "$@" &>/dev/null &
        '';
      };
    in
    {
      home.packages = [ pkg ];
    };
}
