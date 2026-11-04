{
  den.aspects.system.dbus.nixos = { pkgs, ... }: {
    services.dbus = {
      enable = true;
      packages = builtins.attrValues { inherit (pkgs) dconf udisks2 gcr_4; };
    };
  };
}
