{ lib, config, ... }:
let
  inherit (lib) types;
  mkRequired =
    desc: mkOption: opts:
    mkOption opts // { default = throw "${desc} is a required flag"; };

  alias = val: lib.mkOption { default = val; };
in
{
  options.gipphe.flags = {
    user = {
      username = mkRequired "username" lib.mkOption {
        type = types.str;
        description = "Username for the user";
      };
      homeDirectory = mkRequired "homeDirectory" lib.mkOption {
        type = types.str;
        description = "Home directory for the user";
      };
    };

    system = {
      hostname = mkRequired "system.hostname" lib.mkOption {
        type = types.str;
        description = "Hostname for the machine";
      };
      type = mkRequired "system.type" lib.mkOption {
        description = "System environment type";
        type = types.enum [
          "nixos"
          "nix-darwin"
        ];
        example = "nixos";
      };
      global-nix = mkRequired "system.global-nix" lib.mkEnableOption "global Nix config";
      systemd = mkRequired "system.systemd" lib.mkEnableOption "systemd stuff";
      homeFonts = mkRequired "system.homeFonts" lib.mkEnableOption "fonts management with home-manager";
      secrets = mkRequired "system.secrets" lib.mkEnableOption "secret handling with agenix";

      isNixos = alias (config.gipphe.flags.system.type == "nixos");
      isNixDarwin = alias (config.gipphe.flags.system.type == "nix-darwin");
    };

    aux = {
      audio = mkRequired "aux.audio" lib.mkEnableOption "audio management";
      nvidia = mkRequired "aux.nvidia" lib.mkEnableOption "Nvidia GPU drivers";
      printer = mkRequired "aux.printer" lib.mkEnableOption "printer services and options";
      networkmanager = mkRequired "aux.networkmanager" lib.mkEnableOption "networkmanager";
    };

    desktop = {
      enable = mkRequired "desktop.enable" lib.mkEnableOption "custom desktop";
      wayland = mkRequired "desktop.wayland" lib.mkEnableOption "Wayland";
      hyprland = mkRequired "desktop.hyprland" lib.mkEnableOption "Hyprland";
      plasma = mkRequired "desktop.plasma" lib.mkEnableOption "KDE Plasma";
    };

    use-case = {
      cli = mkRequired "use-case.cli" lib.mkEnableOption "CLI stuff";
      work = mkRequired "use-case.work" lib.mkEnableOption "features and stuff for work";
      gaming = mkRequired "use-case.gaming" lib.mkEnableOption "gaming stuff";
    };

    virtualisation = {
      virtualbox = mkRequired "virtualbox" lib.mkEnableOption "Virtualbox guest options";
      wsl = mkRequired "wsl" lib.mkEnableOption "WSL stuff";
    };

    bootloader = {
      bootloader = lib.mkOption {
        description = "Bootloader to use";
        type = types.enum [
          "grub"
          "efi"
        ];
        example = "grub";
        default =
          if config.gipphe.flags.virtualisation.wsl then
            "efi"
          else
            throw "bootloader.type is a required option (unless virtualisation.wsl is true)";
      };

      isEfi = alias (config.gipphe.flags.bootloader.type == "efi");
      isGrub = alias (config.gipphe.flags.bootloader.type == "grub");
    };
  };
}
