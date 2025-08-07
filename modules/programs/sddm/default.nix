{
  pkgs,
  util,
  config,
  ...
}:
let
  background = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "master";
    hash = "sha256-J2DkKptVjWFcA2R71Vv7e0DCZJKeIl5TwjbnzI1kYmw=";
  };
in
util.mkProgram {
  name = "sddm";
  system-nixos = {
    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "macchiato";
        font = "Noto Sans";
        fontSize = "14";
        background = "${background}/src/backgrounds/wall.png";
        loginBackground = true;
      })
    ];
    services.displayManager = {
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        autoNumlock = true;
        wayland.enable = true;
        theme = "catppuccin-macchiato";
      };
      autoLogin = {
        enable = false;
        user = config.gipphe.username;
      };
    };
  };
}
