{ inputs, ... }:
{
  den.aspects.programs.mpv.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        (inputs.wrappers.wrappers.mpv.wrap {
          inherit pkgs;
          script.mpris.path = pkgs.mpvScripts.mpris;
        })
      ];
    };
}
