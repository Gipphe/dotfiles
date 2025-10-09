{
  lib,
  pkgs,
  util,
  config,
  ...
}:
let
  flavor = "macchiato";
  accent = "mauve";
in
util.mkProgram {
  name = "sddm";
  system-nixos = {
    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        inherit flavor accent;
        font = "Noto Sans";
        fontSize = "14";
        loginBackground = true;
      })
    ];
    services.displayManager = {
      sddm = {
        enable = true;
        package = lib.mkForce pkgs.kdePackages.sddm;
        autoNumlock = true;
        wayland.enable = true;
        theme = "catppuccin-${flavor}-${accent}";
      };
      autoLogin = {
        enable = false;
        user = config.gipphe.username;
      };
    };
  };
}
