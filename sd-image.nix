{ ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];
  networking.hostName = "sodium";
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    iwd.enable = false;
    scanOnLowSignal = false;
    networks = {
      "GiphtNet".psk = "<wifi-pw>";
    };
  };
  users.users.gipphe = {
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    home = "/home/gipphe";
    group = "gipphe";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1qNZ75DNoJXpoAnEXKQzrLYWw6WyQIcnW0c6E1+9Sa gipphe@argon"
    ];
  };
  users.groups.gipphe = { };
}
