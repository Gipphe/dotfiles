{
  inputs,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "mpv";
  homeManager = {
    imports = [
      (inputs.wrappers.lib.getInstallModule {
        name = "mpv";
        value = inputs.wrappers.lib.wrapperModules.mpv;
      })
    ];
    wrappers.mpv = {
      enable = true;
      script.mpris.path = pkgs.mpvScripts.mpris;
    };
  };
}
