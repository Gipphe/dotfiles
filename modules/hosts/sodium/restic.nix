{
  den.aspects.sodium.restic = {
    nixos = { pkgs, config, ... }: {
      environment.systemPackages = [ pkgs.rclone ];
      services.restic.backups.main = {
        repository = "rclone:filen:/Resource/sodium";
        rcloneConfigFile = config.sensitive.secrets.secrets."sodium/restic-rclone-config.conf";
        passwordFile = config.sensitive.secrets.secrets."sodium/restic-password.txt";
        inhibitsSleep = true;
        initialize = true;
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

      # Required for restic's inhibitSleep
      security.polkit.enable = true;
    };
  };
}
