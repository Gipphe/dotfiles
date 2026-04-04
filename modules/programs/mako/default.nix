{
  lib,
  pkgs,
  inputs,
  config,
  util,
  ...
}:
util.mkProgram {
  name = "mako";
  hm = {
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "mako";
        value = inputs.wlib.lib.wrapperModules.mako;
      })
    ];
    wrappers.mako = {
      enable = true;
      settings = {
        # font = "Fira Sans Semibold";
        border-radius = 8;
        padding = 8;
        border-size = 5;
        default-timeout = 4000;
      };
      constructFiles.generatedConfig.builder = /* bash */ ''
        mkdir -p "$(dirname "$2")" && cp "$1" "$2" && (${lib.getExe' pkgs.mako "makoctl"} reload || true)
      '';
    };
    dbus.packages = [ config.wrappers.mako.package ];
  };
}
