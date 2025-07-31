{
  pkgs,
  util,
  config,
  lib,
  ...
}:
let
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
    postBuild = ''
      wrapProgram $out/bin/eww \
        --prefix PATH : "${deps}" \
        --add-flags "--config ${./config}"
    '';

    # postBuild = ''
    #   wrapProgram $out/bin/eww \
    #     --prefix PATH : "${deps}" \
    #     --add-flags "--config ${config.gipphe.homeDirectory}/projects/dotfiles/modules/programs/eww/config"
    # '';
  };
in
util.mkProgram {
  name = "eww";
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
        Service =
          let
            script = util.writeFishApplication {
              name = "eww-bar";
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
          {
            ExecStart = "${script}/bin/eww-start";
            Restart = "on-failure";
            Type = "simple";
          };
        Install.WantedBy = [ "eww-daemon.service" ];
      };
    };
  };
}
