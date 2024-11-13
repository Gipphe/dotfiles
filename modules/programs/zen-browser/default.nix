{ util, ... }:
util.mkModule {
  hm.imports = [ ./hm-module.nix ];
  shared.imports = [ ./module.nix ];
}
