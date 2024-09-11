{ util, ... }:
util.mkToggledModule [ "virtualisation" ] {
  name = "virtualbox-guest";
  # Enable VirtualBox additions to make shared clipboard and other niceties work
  system-nixos.virtualisation.virtualbox.guest.enable = true;
}
