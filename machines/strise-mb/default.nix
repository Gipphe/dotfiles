{ pkgs, system, ... }: rec {
  meta = { name = "VNB-MB-Pro"; };
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
      machine.name = meta.name;
    };
  };
}
