{
  den.aspects.sodium.nixos = { user }: { lib, ... }: {
    services.openssh.enable = true;
    systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
    users.users.${user.userName}.openssh.authorizedKeys.keys = [
      # TODO: move these public keys to the secrets repo.
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmb8xuUFYGTMjI7OlwLkIlmcfi1cz/SiSB6Bx1Y0KYW gipphe@titanium"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzghQHh1ZqXhTE2dplVJZPulAvPcaxdSziDotkJBWLs gipphe@boron"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLC+gAQcmXgnkb9seOXdDln/HQkAxxL9s4+hXRJUm0P u0_a342@localhost"
    ];
  };
}
