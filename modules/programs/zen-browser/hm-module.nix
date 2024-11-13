{ util, inputs, ... }:
let
  mkFirefoxModule = import /./${inputs.hm-src}/modules/programs/firefox/mkFirefoxModule.nix;
  modulePath = [
    "programs"
    "zen-browser"
  ];
in
util.mkModule {
  hm = {
    imports = [
      (mkFirefoxModule {
        inherit modulePath;
        name = "Zen Browser";
        wrappedPackageName = "zen-browser";
        unwrappedPackageName = "zen-browser-unwrapped";
        visible = true;
        platforms.linux = rec {
          vendorPath = "zen";
          configPath = vendorPath;
        };
        platforms.darwin = rec {
          vendorPath = "Library/Application Support/zen";
          configPath = vendorPath;
        };
      })
    ];
  };
}
