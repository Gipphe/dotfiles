{
  pkgs,
  util,
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
  saimoomedits = pkgs.fetchFromGitHub {
    owner = "saimoomedits";
    repo = "eww-widgets";
    rev = "master";
    hash = "sha256-yPSUdLgkwJyAX0rMjBGOuUIDvUKGPcVA5CSaCNcq0e8=";
  };
  eww = pkgs.symlinkJoin {
    name = "eww";
    paths = [ pkgs.eww ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/eww \
        --prefix PATH : "${deps}" \
        --add-flags "--config ${saimoomedits}/eww/bar"
    '';
    # postBuild = ''
    #   wrapProgram $out/bin/eww \
    #     --prefix PATH : "${deps}" \
    #     --add-flags "--config ${./eww}"
    # '';
  };
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "eww";
  hm.home.packages = [ eww ];
}
