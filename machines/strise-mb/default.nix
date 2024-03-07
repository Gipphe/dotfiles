{ pkgs, filen, ... }: rec {
  meta = { name = "VNB-MB-Pro"; };
  packages = with pkgs; [
    openvpn
    reattach-to-user-namespace
    alt-tab-macos
    cyberduck
    _1password-gui
    filen
  ];
  services = {
    barrier.client = {
      enable = true;
      enableDragDrop = true;
      machine.name = meta.name;
    };
  };
}
