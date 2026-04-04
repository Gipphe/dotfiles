{ util, inputs, ... }:
util.mkProgram {
  name = "cava";
  hm = {
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "cava";
        value = inputs.wlib.lib.wrapperModules.cava;
      })
    ];
    wrappers.cava.enable = true;
  };
}
