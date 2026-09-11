{ util, ... }:
util.mkModule {
  shared.imports = [
    (import ../browser.nix {
      name = "private";
      iconColor = "#8e24aa";
    })
  ];
}
