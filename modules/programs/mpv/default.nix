{
  inputs,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "mpv";
  hm = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "mpv";
        value = inputs.wlib.lib.wrapperModules.mpv;
      })
    ];
    wrappers.mpv = {
      enable = true;
      script.mpris.path = pkgs.mpvScripts.mpris;
    };
  };
}
