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
      gawk
      networkmanager
      pamixer
      socat
      calc
      brightnessctl
      mpc
    ];
  configDir = "${config.gipphe.homeDirectory}/projects/dotfiles/modules/environment/desktop/hyprland/eww/eww";
  eww = pkgs.symlinkJoin {
    name = "eww";
    paths = [ pkgs.eww ];
    buildInputs = [ pkgs.makeWrapper ];
    # postBuild = ''
    #   wrapProgram $out/bin/eww \
    #     --prefix PATH : "${deps}" \
    #     --add-flags "--config ${./eww}"
    # '';

    postBuild = ''
      wrapProgram $out/bin/eww \
        --prefix PATH : "${deps}" \
        --add-flags "--config ${configDir}"
    '';
  };
  eww-bar = pkgs.writeShellScriptBin "eww-bar" ''
    export PATH=${deps}:$PATH
    ${pkgs.eww}/bin/eww --config ${configDir} open --screen 0 bar
  '';
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "eww";
  hm = {
    home.packages = [
      eww
      eww-bar
    ];
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
          ExecStart = "${eww-bar}/bin/eww-bar open --no-daemonize --screen 0 bar";
          Restart = "on-failure";
          Type = "simple";
        };
        Install.WantedBy = [ "eww-daemon.service" ];
      };
    };
  };
}
