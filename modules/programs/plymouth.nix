{
  den.aspects.programs.plymouth.nixos =
    { pkgs, lib, ... }:
    {
      boot.plymouth = {
        enable = true;
        theme = lib.mkForce "catppuccin-macchiato";
        themePackages = lib.mkForce [
          (pkgs.catppuccin-plymouth.override { variant = "macchiato"; })
        ];
      };
    };
}
