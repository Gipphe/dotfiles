{
  lib,
  config,
  flags,
  ...
}:
{
  # flags = {
  #   user = {
  #     username = "gipphe";
  #     homeDirectory = "/home/gipphe";
  #   };
  #   system = {
  #     type = "nixos";
  #     homeFonts = true;
  #     secrets = true;
  #     systemd = true;
  #   };
  #   use-case = {
  #     work = false;
  #     cli = true;
  #     personal = {
  #       enable = true;
  #       gaming = true;
  #     };
  #   };
  #   desktop = {
  #     enable = true;
  #     hyprland = false;
  #     plasma = true;
  #     wayland = false;
  #   };
  #   virtualisation = {
  #     wsl = false;
  #     virtualbox = false;
  #   };
  #   bootloader.type = "efi";
  #   aux = {
  #     networkmanager = true;
  #     audio = true;
  #     printer = false;
  #     nvidia = false;
  #   };
  # };
  imports = lib.optional flags.isSystem ./system-all.nix;
  options.gipphe.machines.trond-arne.enable = lib.mkEnableOption "trond-arne machine config";
  config = lib.mkIf config.gipphe.machines.trond-arne.enable {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      profiles = {
        nixos = {
          audio.enable = true;
          boot-efi.enable = true;
          devices.enable = true;
          system.enable = true;
        };
        audio.enable = true;
        cli.enable = true;
        core.enable = true;
        desktop-normal.enable = true;
        desktop.enable = true;
        fonts.enable = true;
        gaming.enable = true;
        gc.enable = true;
        networkmanager.enable = true;
        rice.enable = true;
        secrets.enable = true;
        systemd.enable = true;
      };
    };
  };
}
