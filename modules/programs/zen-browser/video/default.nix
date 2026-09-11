{ util, ... }:
util.mkModule {
  shared.imports = [
    (import ../browser.nix {
      name = "video";
      iconColor = "#ff2c00";
    })
  ];
}
