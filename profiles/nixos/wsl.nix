{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "wsl";
  shared.gipphe.system.wsl.enable = true;
}
