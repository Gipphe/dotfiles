{
  den.aspects.sodium.nixos = { user }: { lib, config, ... }: {
    services.openssh.enable = true;
    systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
    users.users.${user.userName}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLC+gAQcmXgnkb9seOXdDln/HQkAxxL9s4+hXRJUm0P u0_a342@localhost"
      config.sensitive.values.values."titanium/sodium.ssh.pub"
      config.sensitive.values.values."boron/sodium.ssh.pub"
    ];
  };
}
