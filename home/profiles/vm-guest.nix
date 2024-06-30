{ util, ... }: util.mkProfile "vm-guest" { gipphe.virtualisation.virtualbox-guest.enable = true; }
