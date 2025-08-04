{
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "sddm";
  system-nixos = {
    environment.systemPackages = [
      pkgs.catppuccin-sddm.override
      {
        flavor = "macchiato";
        font = "Noto Sans";
        fontSize = "12";
        background = "${
          pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "sddm";
            rev = "master";
            hash = "";
          }
        }/src/backgrounds/wall.png";
        loginBackground = true;
      }
    ];
    services.displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
      # autoLogin = {
      #   enable = true;
      #   user = config.gipphe.username;
      # };
    };
  };
}
