{
  den.aspects.sodium.restic = {
    homeManager = { osConfig, config, ... }: {
      services.restic = {
        enable = true;
        backups.main = {
          repository = "rclone:filen:/Resource/sodium";
          passwordFile = config.sensitive.secrets.secrets."sodium/restic-password.txt";
          inhibitsSleep = true;
          paths = [
            osConfig.services.forgejo.stateDir
          ];
          exclude = [
            "${osConfig.services.forgejo.stateDir}/data/tmp"
            "${osConfig.services.forgejo.stateDir}/log"
          ];
          pruneOpts = [
            "--compact"
            "--keep-hourly 3"
            "--keep-daily 7"
            "--keep-weekly 4"
            "--keep-monthly 6"
            "--keep-yearly 3"
          ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
        };
      };

      programs.rclone = {
        enable = true;
        remotes.filen = {
          config.type = "filen";
          secrets = {
            email = config.sensitive.secrets.secrets."pub/filen-email.txt";
            password = config.sensitive.secrets.secrets."pub/filen-password.txt";
            api_key = config.sensitive.secrets.secrets."pub/filen-api-key.txt";
          };
        };
      };
    };

    nixos = {
      # Required for restic's inhibitSleep
      security.polkit.enable = true;
    };
  };
}
