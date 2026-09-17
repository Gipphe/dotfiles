{ system, inputs }:
import inputs.nixpkgs {
  inherit system;
  overlays = builtins.attrValues inputs.self.overlays ++ [
    inputs.dolphin-overlay.overlays.default
  ];
  config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };
}
