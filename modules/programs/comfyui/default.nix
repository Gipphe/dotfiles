{ util, ... }:
let
  mod = util.mkProgram {
    name = "comfyui";
    nixos = {
      # Package included in separate repo
      networking.firewall.allowedTCPPorts = [
        8188
        8189
        8190
      ];
    };
  };
in
util.mkModule {
  shared.imports = [ mod ];
  nixos = {
    nix.settings = {
      trusted-substituters = [
        "https://comfyui.cachix.org"
        # "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
