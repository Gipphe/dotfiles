{ lib, config, ... }:
{
  options.gipphe.flags = {
    username = lib.mkOption {
      default = "gipphe";
      type = lib.types.string;
      description = "Username for the user";
    };
    homeDirectory = lib.mkOption {
      default = "/home/${config.gipphe.flags.username}";
      type = lib.types.string;
      description = "Home directory for the user";
    };
    hostname = lib.mkOption {
      default = throw "gipphe.flags.hostname is required";
      type = lib.types.string;
      description = "Hostname for the machine";
    };

    nixos = lib.mkEnableOption "Is NixOS" // {
      default = true;
    };
    nix-darwin = lib.mkEnableOption "Is nix-darwin";

    gui = lib.mkEnableOption "GUI stuff" // {
      default = true;
    };
    cli = lib.mkEnableOption "CLI stuff" // {
      default = true;
    };

    audio = lib.mkEnableOption "Manage audio" // {
      default = true;
    };
    systemd = lib.mkEnableOption "Has systemd" // {
      default = true;
    };

    desktop = lib.mkEnableOption "Custom desktop" // {
      default = config.gipphe.flags.gui;
    };
    wayland = lib.mkEnableOption "Use Wayland" // {
      default = config.gipphe.flags.desktop;
    };
    hyprland = lib.mkEnableOption "Use Hyprland";
    plasma = lib.mkEnableOption "Use KDE Plasma" // {
      default = true;
    };

    nvidia = lib.mkEnableOption "Machine has Nvidia GPU";

    global-nix = lib.mkEnableOption "Global Nix config" // {
      default = true;
    };
    homeFonts = lib.mkEnableOption "Manage fonts with home-manager" // {
      default = true;
    };

    virtualbox = lib.mkEnableOption "Machine is a Virtualbox guest";
    wsl = lib.mkEnableOption "Machine is in WSL";

    bootloader = lib.mkOption {
      description = "Bootloader to use";
      type = lib.types.enum [
        "grub"
        "efi"
      ];
      default = "efi";
    };
  };
}
