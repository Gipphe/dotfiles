{ lib, flags, ... }:
{
  config = lib.mkIf flags.virtualbox {
    # Enable VirtualBox additions to make shared clipboard and other niceties work
    virtualisation.virtualbox.guest.enable = true;
  };
}
