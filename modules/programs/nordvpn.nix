{
  den.aspects.programs.nordvpn.nixos = { user }: { config, ... }: {
    services.nordvpn.enable = true;
    users.users.${user.userName}.extraGroups = [ config.services.nordvpn.group ];
  };
}
