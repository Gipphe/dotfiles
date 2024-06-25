{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.virtualisation.virtualbox-guest.enable {
    # Enable VirtualBox additions to make shared clipboard and other niceties work
    virtualisation.virtualbox.guest.enable = true;
  };
}
