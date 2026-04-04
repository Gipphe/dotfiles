{ inputs, util, ... }:
util.mkProgram {
  name = "nushell";
  hm = {
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "nushell";
        value = inputs.wlib.lib.wrapperModules.nushell;
      })
    ];
    wrappers.nushell = {
      enable = true;
    };
  };
}
