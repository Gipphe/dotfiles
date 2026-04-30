{ util, inputs, ... }:
util.mkProgram {
  name = "cava";
  hm = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "cava";
        value = inputs.wlib.lib.wrapperModules.cava;
      })
    ];
    wrappers.cava.enable = true;
  };
}
