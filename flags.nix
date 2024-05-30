{
  lib,
  config,
  pkgs,
  ...
}:
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
      default = pkgs.stdenv.isLinux;
    };
    nix-darwin = lib.mkEnableOption "Is nix-darwin" // {
      default = pkgs.stdenv.isDarwin;
    };
    isDarwin = lib.mkEnableOption "Is Darwin machine" // {
      default = pkgs.stdenv.isDarwin;
    };
    isLinux = lib.mkEnableOption "Is Linux machine" // {
      default = pkgs.stdenv.isLinux;
    };
    desktop = lib.mkEnableOption "Custom desktop" // {
      default = config.gipphe.flags.gui;
    };
    gui = lib.mkEnableOption "GUI stuff" // {
      default = true;
    };
    cli = lib.mkEnableOption "CLI stuff" // {
      default = true;
    };
    audio = lib.mkEnableOption "Manage audio" // {
      default = pkgs.stdenv.isLinux;
    };
    systemd = lib.mkEnableOption "Has systemd" // {
      default = pkgs.stdenv.isDarwin;
    };
    wayland = lib.mkEnableOption "Use Wayland" // {
      default = true;
    };
    hyprland = lib.mkEnableOption "Use Hyprland";
    nvidia = lib.mkEnableOption "Machine has Nvidia GPU";
    global-nix = lib.mkEnableOption "Global Nix config" // {
      default = true;
    };
    homeFonts = lib.mkEnableOption "Manage fonts with home-manager" // {
      default = !pkgs.stdenv.isDarwin;
    };
  };
}
