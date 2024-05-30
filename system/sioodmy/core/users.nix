{ pkgs, ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
  users = {
    mutableUsers = false;
    users = {
      root.hashedPasswordFile = "/persist/secrets/root";
      gipphe = {
        home = "/home/gipphe";
        isNormalUser = true;
        hashedPasswordFile = "/persist/secrets/gipphe";
        extraGroups = [
          "wheel"
          "gitea"
          "docker"
          "systemd-journal"
          "vboxusers"
          "audio"
          "plugdev"
          "wireshark"
          "video"
          "input"
          "lp"
          "networkmanager"
          "power"
          "nix"
          "adbusers"
        ];
        uid = 1000;
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = [
          # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9ExEl6WqtCI4yCqbSAhAGmzvVp/nYADbgy/Qi4AKQy sioodmy@anthe"
          # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+S9LPxp3Mmha1keHlwc0iVq4CMbHvzAAwuYE2go7io sioodmy@calypso"
        ];
      };
    };
  };
}
