{
  lib,
  util,
  pkgs,
  config,
  ...
}:
util.mkGaming {
  name = "gamemode";
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
          gpu_device = 2;
        };

        # custom =
        #   let
        #     startStopScript =
        #       mode:
        #       util.writeNushellApplication {
        #         name = "gamemode-${mode}";
        #         runtimeInputs = with pkgs; [
        #           scx_tools
        #           power-profiles-daemon
        #           libnotify
        #         ];
        #         text =
        #           let
        #             tern = ifStart: ifEnd: if mode == "start" then ifStart else ifEnd;
        #           in
        #           # nu
        #           ''
        #             try {
        #                 powerprofilesctl set ${tern "performance" "balanced"}
        #                 scxctl switch -m ${tern "gaming" "lowlatency"}
        #                 notify-send -u low 'GameMode' ${tern "'Performance mode enabled'" "'Balanced mode restored'"}
        #             } catch { |err|
        #                 notify-send -u critical 'GameMode' $"Failed to run hook: ($err.rendered)"
        #                 # Return error code so GameMode knows the hook failed
        #                 return 1
        #             }
        #           '';
        #       };
        #   in
        #   {
        #     start = lib.getExe (startStopScript "start");
        #     end = lib.getExe (startStopScript "end");
        #   };
      };
    };
    security.wrappers.gamemode = {
      owner = "root";
      group = "root";
      source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };

    # Allow users in gamemode group to manage schedulers via scx_loader
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
           action.id == "org.scx.loader.manage-schedulers" &&
           subject.isInGroup("gamemode")
        ) {
          return polkit.Result.YES;
        }
      });
    '';

    # Since version 1.8 gamemode requires the user to be in the gamemode group
    # https://github.com/FeralInteractive/gamemode/issues/452
    users.users.${config.gipphe.username}.extraGroups = [ "gamemode" ];

    # Allow reading CPU power consumption for gamemode monitoring
    systemd.tmpfiles.settings."10-gamemode-powercap" = {
      "/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/energy_uj".z = {
        mode = "0644";
      };
    };

    # <https://www.phoronix.com/news/Fedora-39-VM-Max-Map-Count>
    # <https://github.com/pop-os/default-settings/blob/master_jammy/etc/sysctl.d/10-pop-default-settings.conf>
    boot.kernel.sysctl = {
      # default on some gaming (SteamOS) and desktop (Fedora) distributions
      # might help with gaming performance
      "vm.max_map_count" = 2147483642;
    };

    # Do not start gamemoded for system users. This prevents gamemoded starting
    # during login when greetd temporarily runs as the greeter user.
    systemd.user.services.gamemoded.unitConfig.ConditionUser = "!@system";
  };
}
