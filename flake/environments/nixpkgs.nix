{ system, inputs }:
import inputs.nixpkgs {
  inherit system;
  overlays = [
    (inputs.nixpkgs.lib.composeManyExtensions (
      builtins.attrValues (removeAttrs inputs.self.overlays [ "default" ])
    ))
    inputs.dolphin-overlay.overlays.default
  ];
  config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };
}
