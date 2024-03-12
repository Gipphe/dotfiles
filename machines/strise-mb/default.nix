{ pkgs, system, hostname, ... }:
if hostname != "strise-mb" then
  { }
else {
  packages = with pkgs; [
    openvpn
    reattach-to-user-namespace
    alt-tab-macos
    cyberduck
    _1password-gui
    (import ../../home/packages/filen { inherit pkgs system; })
  ];
  services = {
    barrier.client = {
      enable = true;
      enableDragDrop = true;
      machine.name = hostname;
    };
  };
}
