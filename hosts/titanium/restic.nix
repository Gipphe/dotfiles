{ util, config, ... }:
let
  steamProtonPaths =
    map (p: "${config.xdg.dataHome}/Steam/steamapps/compatdata/**/pfx/drive_c/${p}")
      [
        "*/Common Files"
        "*/Internet Explorer"
        "*/Steam"
        "*/Windows Media Player"
        "Windows"
        "windows"
        "vrclient"
      ];
  dataPaths = map (p: "${config.xdg.dataHome}/${p}") [
    "dV"
    "PrismLauncher/instances"
    "songsofsyx/saves"
    "Steam/userdata"
    "Steam/steamapps/compatdata"
    "Tachiyomi Backups"
    "zoxide"
    "bolt-launcher/.runelite"
  ];
  configPaths = map (p: "${config.xdg.configHome}/${p}") [
    "EgoSoft/X4/31098541/save"
    "lutris"
  ];
  homePaths = map (p: "${config.home.homeDirectory}/${p}") [
    "Documents"
    "Dwarf Fortress saves"
    "Videos"
  ];
in
util.mkModule {
  homeManager = {
    services.restic = {
      enable = true;
      backups.main = {
        repository = "rclone:filen:/Resource/Restic";
        passwordFile = config.sops.secrets.restic-password.path;
        inhibitsSleep = true;
        paths = [ config.gipphe.gaming.minecraft.servers.dataDir ] ++ homePaths ++ configPaths ++ dataPaths;
        exclude = steamProtonPaths ++ [
          "${config.xdg.dataHome}/bolt-launcher/.runelite/jagexcache"
          "${config.xdg.dataHome}/bolt-launcher/.runelite/cache"
          "${config.xdg.dataHome}/bolt-launcher/.runelite/logs"
          "${config.xdg.dataHome}/bolt-launcher/.runelite/repository2"
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
          email = config.sops.secrets.filen-email.path;
          password = config.sops.secrets.filen-password.path;
          api_key = config.sops.secrets.filen-api-key.path;
        };
      };
    };
    sops.secrets = {
      restic-password = {
        format = "binary";
        sopsFile = ../../secrets/pub-restic-password.txt;
      };
      filen-email = {
        format = "binary";
        sopsFile = ../../secrets/pub-filen-email.txt;
      };
      filen-password = {
        format = "binary";
        sopsFile = ../../secrets/pub-filen-password.txt;
      };
      filen-api-key = {
        format = "binary";
        sopsFile = ../../secrets/pub-filen-api-key.txt;
      };
    };
  };
  nixos = {
    # Required for restic's inhibitSleep
    security.polkit.enable = true;

    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ config.gipphe.username ];
        MaxAuthTries = 3;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };

    users.users.${config.gipphe.username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLC+gAQcmXgnkb9seOXdDln/HQkAxxL9s4+hXRJUm0P u0_a342@localhost"
    ];
  };
}
