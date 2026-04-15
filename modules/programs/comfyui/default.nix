{ util, ... }:
util.mkProgram {
  name = "comfyui";
  shared.imports = [ ./proxy.nix ];
}
