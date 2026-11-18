{
  den.aspects.sodium.nixos = { user }: { lib, ... }: {
    services.openssh.enable = true;
    systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
    users.users.${user.userName}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmb8xuUFYGTMjI7OlwLkIlmcfi1cz/SiSB6Bx1Y0KYW gipphe@titanium"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzghQHh1ZqXhTE2dplVJZPulAvPcaxdSziDotkJBWLs gipphe@boron"
    ];
  };
}
