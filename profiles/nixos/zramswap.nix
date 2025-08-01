{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "zramswap";
  shared.gipphe.system.zramswap.enable = true;
}
