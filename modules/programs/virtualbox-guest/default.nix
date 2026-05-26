{ util, ... }:
util.mkProgram {
  name = "virtualbox-guest";
  # Enable VirtualBox additions to make shared clipboard and other niceties work
  nixos.virtualisation.virtualbox.guest.enable = true;
}
