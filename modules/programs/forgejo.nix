{
  den.aspects.programs.forgejo.nixos = { config, ... }: {
    services.forgejo = {
      enable = true;
      lfs.enable = true;
      dump.enable = true;
    };
    networking.firewall.allowedTCPPorts = [ config.services.forgejo.settings.server.HTTP_PORT ];
    services.restic.backups.main = {
      paths = [
        config.services.forgejo.stateDir
      ];
      exclude = [
        "${config.services.forgejo.stateDir}/data/tmp"
        "${config.services.forgejo.stateDir}/log"
      ];
    };
  };
}
