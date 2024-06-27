{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.machines.nixos-vm.enable { networking.hostName = "nixos-vm"; };
}
