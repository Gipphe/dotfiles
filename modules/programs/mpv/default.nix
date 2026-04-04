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
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "mpv";
        value = inputs.wlib.lib.wrapperModules.mpv;
      })
    ];
    wrappers.mpv = {
      enable = true;
      scripts = [ pkgs.mpvScripts.mpris ];
    };
  };
}
