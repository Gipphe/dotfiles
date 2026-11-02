{ den, ... }:
{
  den.aspects.profiles.keyring.includes = [
    den.aspects.programs.gnome-keyring
    den.aspects.programs.seahorse
  ];
}
