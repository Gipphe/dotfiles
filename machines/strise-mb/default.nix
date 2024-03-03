{machine, pkgs, ...}: {
  meta = {
    name = "VNB-MB-Pro";
  };
  packages = with pkgs; [ openvpn ];
  services = {
    barrier.client = {
      enable = true;
      enableDragDrop = true;
      machine.name;
    };
  };
}
