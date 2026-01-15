{ util, ... }:
util.mkToggledModule [ "profiles" "nixos" ] {
  name = "printing";
  shared.gipphe.system.printer.enable = true;
}
