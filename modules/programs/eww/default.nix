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
in
util.mkProgram {
  name = "eww";
  options.gipphe.programs.eww = {
    dev = lib.mkEnableOption "dev mode";
  };
  hm = {
    home.packages = [ eww ];
    systemd.user.services = {
      "eww-daemon" = {
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
      "eww-bar" = {
        Unit = {
          Description = "Start eww bar";
          Documentation = "https://elkowar.github.io/eww/";
          After = [ "eww-daemon.service" ];
          PartOf = [ "eww-daemon.service" ];
        };
        Service = {
          ExecStart = "${start-eww-bar}/bin/start-eww-bar";
          Restart = "on-failure";
          Type = "simple";
        };
        Install.WantedBy = [ "eww-daemon.service" ];
      };
    };
  };
}
