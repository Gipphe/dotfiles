{ lib, config, ... }:
let
  mkRequired =
    desc: mkOption: opts:
    mkOption opts // { default = throw "${desc} is a required flag"; };
in
{
  options.gipphe.flags = {
    username = mkRequired "username" lib.mkOption {
      type = lib.types.str;
      description = "Username for the user";
    };
    homeDirectory = mkRequired "homeDirectory" lib.mkOption {
      type = lib.types.str;
      description = "Home directory for the user";
    };
    hostname = mkRequired "hostname" lib.mkOption {
      type = lib.types.str;
      description = "Hostname for the machine";
    };

    system = mkRequired "system" lib.mkOption {
      description = "System type";
      type = lib.types.enum [
        "nixos"
        "nix-darwin"
      ];
      example = "nixos";
    };

    work = mkRequired "work" lib.mkEnableOption "work stuff";
    cli = mkRequired "cli" lib.mkEnableOption "CLI stuff";

    audio = mkRequired "audio" lib.mkEnableOption "audio management";
    systemd = mkRequired "systemd" lib.mkEnableOption "systemd stuff";

    desktop = mkRequired "desktop" lib.mkEnableOption "custom desktop";
    wayland = mkRequired "wayland" lib.mkEnableOption "Wayland";
    hyprland = mkRequired "hyprland" lib.mkEnableOption "Hyprland";
    plasma = mkRequired "plasma" lib.mkEnableOption "KDE Plasma";

    gaming = mkRequired "gaming" lib.mkEnableOption "gaming stuff";
    nvidia = mkRequired "nvidia" lib.mkEnableOption "Nvidia GPU drivers";

    global-nix = mkRequired "global-nix" lib.mkEnableOption "global Nix config";
    homeFonts = mkRequired "homeFonts" lib.mkEnableOption "fonts management with home-manager";
    secrets = mkRequired "secrets" lib.mkEnableOption "secret handling with agenix";
    networkmanager = mkRequired "networkmanager" lib.mkEnableOption "networkmanager";
    printer = mkRequired "printer" lib.mkEnableOption "printer services and options";

    virtualbox = mkRequired "virtualbox" lib.mkEnableOption "Virtualbox guest options";
    wsl = mkRequired "wsl" lib.mkEnableOption "WSL stuff";

    bootloader = lib.mkOption {
      description = "Bootloader to use";
      type = lib.types.enum [
        "grub"
        "efi"
      ];
      example = "grub";
      default =
        if config.gipphe.flags.wsl then
          "efi"
        else
          throw "bootloader is a required option (unless wsl is true)";
    };
  };
}
