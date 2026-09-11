{ util, ... }:
util.mkModule {
  shared.imports = [
    (import ../browser.nix {
      name = "main";
      iconColor = "#1e88e5";
    })
  ];
}
