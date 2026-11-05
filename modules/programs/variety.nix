{
  den.aspects.programs.variety.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      noctalia = lib.getExe' config.programs.noctalia.package "noctalia";
      wallpaperDir = config.programs.noctalia.settings.wallpaper.directory;
      configDir = "${config.xdg.configHome}/variety";

      # Hand the image to Noctalia rather than letting Variety set it, so
      # Noctalia's transitions and wallpaper-derived theming keep working.
      setWallpaper = pkgs.writeShellScript "variety-set-wallpaper" ''
        exec ${noctalia} msg wallpaper-set "$1"
      '';
      getWallpaper = pkgs.writeShellScript "variety-get-wallpaper" ''
        exec ${noctalia} msg wallpaper-get
      '';

      sources = [
        "True|favorites|The Favorites folder"
        "True|wallhaven|https://wallhaven.cc/search?categories=100&purity=100&atleast=1920x1080&ratios=landscape&sorting=toplist&topRange=1M"
        "True|unsplash|Unsplash"
        "True|bing|Bing"
        "False|apod|NASA's Astronomy Picture of the Day"
        "False|earthview|Google Earth View"
        "True|fetched|The Fetched folder"
      ];

      varietyConf = pkgs.writeText "variety.conf" ''
        change_enabled = True
        change_on_start = False
        change_interval = 86400
        internet_enabled = True
        safe_mode = True
        set_wallpaper_script = ${setWallpaper}
        get_wallpaper_script = ${getWallpaper}
        download_folder = ${wallpaperDir}/variety/downloaded
        favorites_folder = ${wallpaperDir}/variety/favorites
        fetched_folder = ${wallpaperDir}/variety/fetched
        quota_enabled = True
        quota_size = 500
        wallpaper_auto_rotate = True
        wallpaper_display_mode = "os"
        use_landscape_enabled = True
        clipboard_enabled = False
        clock_enabled = False
        quotes_enabled = False
        smart_enabled = False
        smart_notice_shown = True
        smart_register_shown = True
        stats_enabled = False
        stats_notice_shown = True
        sync_enabled = False

        [sources]
        ${lib.concatImapStringsSep "\n" (i: s: "src${toString i} = ${s}") sources}
      '';
    in
    {
      home.packages = [ pkgs.variety ];

      # Variety rewrites variety.conf at runtime, so it can't be a read-only
      # store symlink. Copy it in on every switch instead; changes made in the
      # GUI last until the next rebuild.
      home.activation.varietyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run install -Dm644 ${varietyConf} ${lib.escapeShellArg "${configDir}/variety.conf"}
        # Skip the blocking welcome/privacy dialogs and the XDG autostart entry
        # Variety creates on first run; systemd starts it instead.
        if [ ! -e ${lib.escapeShellArg "${configDir}/.firstrun"} ]; then
          run touch ${lib.escapeShellArg "${configDir}/.firstrun"}
        fi
      '';

      systemd.user.services.variety = {
        Unit = {
          Description = "Variety wallpaper changer";
          Requires = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          After = [
            "graphical-session.target"
            "noctalia.service"
          ];
          X-Restart-Triggers = [ "${varietyConf}" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = lib.getExe pkgs.variety;
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
