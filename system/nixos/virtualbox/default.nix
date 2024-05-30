{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.flags.virtualbox {
    # Enable VirtualBox additions to make shared clipboard and other niceties work
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.x11 = true;
  };
}
