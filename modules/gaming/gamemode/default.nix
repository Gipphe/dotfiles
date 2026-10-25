{ util, config, ... }:
util.mkGaming {
  name = "gamemode";
  shared.imports = [ ./custom.nix ];
  nixos = {
    environment.variables = {
      # Workaround for controller detection issues
      PROTON_PREFER_SDL = "1";
      # Enable per-game shader cache, similar to Steam's "Shader Pre-Caching".
      PROTON_LOCAL_SHADER_CACHE = "1";
      # Enable native Wayland support.
      PROTON_ENABLE_WAYLAND = "1";
      # Disable window manager decorations. # Fixes: Borderless fullscreen
      # issues, mouse clicking through windows
      PROTON_NO_WM_DECORATION = "1";
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10; # Nice game processes for better priority
          ioprio = 0; # Highest IO priority for game processes
          inhibit_screensaver = 1;
          disable_splitlock = 1; # Disable split-lock mitigation for performance
        };

        cpu = {
          park_cores = "no"; # Don't park cores
          pin_cores = "yes"; # Pin game to optimal cores (auto-detected)
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
        };
      };
    };

    # Since version 1.8 gamemode requires the user to be in the gamemode group
    # https://github.com/FeralInteractive/gamemode/issues/452
    users.users.${config.gipphe.username}.extraGroups = [ "gamemode" ];

    # https://www.phoronix.com/news/Fedora-39-VM-Max-Map-Count
    # https://github.com/pop-os/default-settings/blob/master_jammy/etc/sysctl.d/10-pop-default-settings.conf
    boot.kernel.sysctl = {
      # default on some gaming (SteamOS) and desktop (Fedora) distributions
      # might help with gaming performance
      "vm.max_map_count" = 2147483642;
    };

    # Allow reading CPU power consumption for gamemode monitoring
    systemd.tmpfiles.settings."10-gamemode-powercap" = {
      "/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/energy_uj".z = {
        mode = "0644";
      };
    };

    # Do not start gamemoded for system users. This prevents gamemoded starting
    # during login when greetd temporarily runs as the greeter user.
    systemd.user.services.gamemoded.unitConfig.ConditionUser = "!@system";
  };
}
