{
  pkgs,
  util,
  config,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.eww;
  deps =
    with pkgs;
    lib.makeBinPath [
      brightnessctl
      calc
      gawk
      jo
      lm_sensors
      mpc
      networkmanager
      pamixer
      playerctl
      pulseaudio
      socat
      walker
      wlr-randr
    ];
  eww = pkgs.symlinkJoin {
    name = "eww";
    paths = [ pkgs.eww ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild =
      if cfg.dev then
        ''
          wrapProgram $out/bin/eww \
            --prefix PATH : "${deps}" \
            --add-flags "--config ${./config}"
        ''
      else
        ''
          wrapProgram $out/bin/eww \
            --prefix PATH : "${deps}" \
            --add-flags "--config ${config.gipphe.homeDirectory}/projects/dotfiles/modules/programs/eww/config"
        '';
  };

  start-eww-bar = util.writeFishApplication {
    name = "start-eww-bar";
    runtimeInputs = with pkgs; [
      wlr-randr
      jq
      eww
    ];
    text = ''
      set -l monitors $(wlr-randr --json | jq -r '.[] | select(.enabled) | .name')
      for monitor in $monitors
        eww open --no-daemonize --screen "$monitor" --id "$monitor" bar
      end
    '';
  };

  eww-watch-monitors = util.writeFishApplication {
    name = "eww-watch-monitors";
    runtimeInputs = with pkgs; [
      eww
      socat
    ];
    text = ''
      function get-active-monitors
        eww active-windows | string replace -r ': .*$' ""
      end

      socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line
        if string match -qr 'monitorremovedv2'
          set -l parts (string sub --start 19 | string split ',')
          set -l monitor_index $parts[1]
          set -l monitor_name $parts[2]
          set -l monitor_desc $parts[3]

          set -l windows (get-active-monitors)
          if contains $monitor_name $windows
            eww close "$monitor_name"
          end
        end


        if string match -qr 'monitoraddedv2'
          set -l parts (string sub --start 17 | string split ',')
          set -l monitor_index $parts[1]
          set -l monitor_name $parts[2]
          set -l monitor_desc $parts[3]

          set -l windows (get-active-monitors)
          if ! contains $monitor_name $windows
            eww open --screen "$monitor_name" --id "$monitor_name" bar
          end
        end
      end
    '';
  };
in
util.mkProgram {
  name = "eww";
  options.gipphe.programs.eww = {
    dev = lib.mkEnableOption "dev mode";
  };
  hm = {
    home.packages = [ eww ];
    systemd.user.services = {
      eww-daemon = {
        Unit = {
          Description = "Start eww daemon";
          Documentation = "https://elkowar.github.io/eww/";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${eww}/bin/eww daemon --no-daemonize";
          Restart = "on-failure";
          Type = "exec";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      eww-bar = {
        Unit = {
          Description = "Start eww bar";
          Documentation = "https://elkowar.github.io/eww/";
          After = [ "eww-daemon.service" ];
          PartOf = [ "eww-daemon.service" ];
        };
        Service = {
          ExecStart = "${start-eww-bar}/bin/start-eww-bar";
          Type = "oneshot";
        };
        Install.WantedBy = [ "eww-daemon.service" ];
      };

      eww-watch-monitors = {
        Unit = {
          Description = "eww-watch-monitors";
          After = [
            "eww-bar.service"
            "eww-daemon.service"
          ];
          PartOf = [ "eww-daemon.service" ];
        };
        Service = {
          ExecStart = "${eww-watch-monitors}/bin/eww-watch-monitors";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "eww-daemon.service" ];
      };
    };
  };
}
