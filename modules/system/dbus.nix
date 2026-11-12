{
  den.aspects.system.dbus.nixos = {
    services = {
      dbus.enable = true;
      udisks2.enable = true;
    };
    programs = {
      dconf.enable = true;
    };
  };
}
