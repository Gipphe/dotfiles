{
  inputs,
  lib,
  den,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
  den.aspects.profiles.core.includes = [
    den.aspects.core
    den.aspects.core.wm
    den.aspects.programs.nix
    den.aspects.system.cursor
    den.aspects.system.dbus
    den.aspects.system.fonts
    den.aspects.system.home-manager
    den.aspects.system.user
    den.aspects.system.xdg
  ];
}
