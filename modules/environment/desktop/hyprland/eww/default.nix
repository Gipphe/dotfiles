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
        --add-flags "--config ${config.gipphe.homeDirectory}/projects/dotfiles/modules/environment/desktop/hyprland/eww/eww"
    '';
  };
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "eww";
  hm = {
    home.packages = [ eww ];
    systemd.user.services = {
      "eww-daemon" = {
        Unit = {
          Description = "Start eww daemon";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${eww}/bin/eww daemon";
          Restart = "never";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      "eww-bar" = {
        Unit = {
          Description = "Start eww bar";
          After = [
            "graphical-session.target"
            "eww-daemon.service"
          ];
          PartOf = [ "eww-daemon.service" ];
        };
        Service = {
          ExecStart = "${eww}/bin/eww open --screen 0 bar";
          Restart = "never";
        };
        Install.WantedBy = [ "eww-daemon.service" ];
      };
    };
  };
}
