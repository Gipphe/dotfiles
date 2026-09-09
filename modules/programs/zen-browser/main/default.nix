{ util, ... }:
util.mkModule {
  shared.imports = [ (import ../browser.nix "main") ];
}
