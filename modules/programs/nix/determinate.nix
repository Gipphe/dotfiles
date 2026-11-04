{ den, inputs, ... }: {
  den.aspects.programs.nix.determinate.nixos = { host }: { lib, ... }: {
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

    environment.etc."determinate/config.json".text = builtins.toJSON {
      garbageCollector.strategy = lib.mkIf (host.hasAspect den.aspects.programs.nh.gc) "disabled";
    };
  };
}
