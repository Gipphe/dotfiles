{ util, ... }:
let
  subs = {
    "https://nix-gaming.cachix.org" =
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
  };
in
util.mkModule {
  nixos = {
    nix.settings = {
      trusted-substituters = builtins.attrNames subs;
      trusted-public-keys = builtins.attrValues subs;
    };
  };
}
