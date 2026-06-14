{ util, ... }:
let
  subs = {
    "https://nix-gaming.cachix.org" =
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
    # Used by `nix-gaming-edge`
    "https://nix-cache.tokidoki.dev/tokidoki" = "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk=";
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
