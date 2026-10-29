{
  config,
  lib,
  util,
  inputs,
  ...
}:
let
  cfg = config.gipphe.programs.nix.determinate;
in
util.mkToggledModule [ "programs" "nix" ] {
  name = "determinate";
  options.gipphe.programs.nix.determinate.daemon.settings = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
    description = "Configuration for Determinate nixd";
  };
  nixos = {
    imports = [ inputs.determinate.nixosModules.default ];
    nix.settings = {
      extra-experimental-features = [ "provenance" ];
      system-features = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
      trusted-substituters = [ "https://install.determinate.systems" ];
      trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      ];
    };

    gipphe.programs.nix.determinate.daemon.settings = {
      garbageCollector.strategy = lib.mkIf config.gipphe.programs.nh.enable "disabled";
    };

    environment.etc."determinate/config.json" = lib.mkIf (cfg.daemon.settings != { }) {
      text = builtins.toJSON cfg.daemon.settings;
    };
  };
}
