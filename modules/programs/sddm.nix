{
  den.aspects.programs.sddm.nixos =
    { user }:
    { lib, pkgs, ... }:
    let
      flavor = "macchiato";
      accent = "mauve";
    in
    {
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
          enable = true;
          user = user.userName;
        };
      };
    };
}
