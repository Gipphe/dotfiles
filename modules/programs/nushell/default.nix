{ inputs, util, ... }:
util.mkProgram {
  name = "nushell";
  homeManager = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "nushell";
        value = inputs.wlib.lib.wrapperModules.nushell;
      })
    ];
    wrappers.nushell = {
      enable = true;
    };
  };
}
