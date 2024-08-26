{
  inputs,
  pkgs,
  util,
  ...
}:
util.mkToggledModule
  [
    "environment"
    "desktop"
  ]
  {
    name = "hyprland";
    hm = {
      imports = [ ./rice ];
      config = {
        wayland.windowManager.hyprland = {
          enable = true;
          extraConfig = builtins.readFile ./hyprland.conf;
        };
        programs.hyprlock.enable = true;
        services.hypridle.enable = true;
      };
    };
    system-nixos = {
      imports = [ ./wayland ];
      config.programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      };
    };
  }
