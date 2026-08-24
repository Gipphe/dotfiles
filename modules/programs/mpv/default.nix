{
  inputs,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "mpv";
  homeManager = {
    home.packages = [
      (inputs.wlib.wrappers.mpv.wrap {
        inherit pkgs;
        script.mpris.path = pkgs.mpvScripts.mpris;
      })
    ];
  };
}
