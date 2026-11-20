{
  den.aspects.sodium.nixos = { user }: { lib, config, ... }: {
    services.openssh.enable = true;
    systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
    users.users.${user.userName}.openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLC+gAQcmXgnkb9seOXdDln/HQkAxxL9s4+hXRJUm0P u0_a342@localhost"
      ];
      keyFiles = [
        config.sensitive.secrets.secrets."titanium/sodium.ssh.pub"
        config.sensitive.secrets.secrets."boron/sodium.ssh.pub"
      ];
    };
  };
}
