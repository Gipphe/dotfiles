{
  util,
  pkgs,
  config,
  lib,
  ...
}:
let
  grimblast = lib.getExe pkgs.grimblast;
  inherit (builtins) concatLists genList toString;

  # sioodmy's implementation
  workspaces = concatLists (
    genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          toString (x + 1 - (c * 10));
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    ) 10
  );

  # Hyprland docs implementation
  workspaces' = concatLists (
    genList (
      i:
      let
        ws = i + 1;
      in
      [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]
    ) 10
  );
  waybar = "${pkgs.waybar}/bin/waybar";
  dunst = "${config.services.dunst.package}/bin/dunst";
  hyprpaper = "${config.services.hyprpaper.package}/bin/hyprpaper";
in
util.mkToggledModule
  [
    "environment"
    "desktop"
  ]
  {
    name = "hyprland";
    hm = {
      imports = [
        ./dunst.nix
        ./filemanager.nix
        ./hypridle.nix
        ./hyprlock.nix
        ./hyprpaper.nix
        ./hyprpolkit.nix
        ./rofi.nix
        ./waybar.nix
        ./wlogout.nix
      ];
      home.packages = with pkgs; [ wireplumber ];
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          bind = workspaces ++ [
            "$mod, F, exec, floorp"
            ", Print, exec, ${grimblast} copy area"
            "$mod, RETURN, exec, ${config.programs.wezterm.package}/bin/wezterm"
            "CTRL SHIFT, RETURN, exec, ${config.programs.wezterm.package}/bin/wezterm"
            "$mod, Q, killactive" # Close current window
          ];
        };
        xwayland.enable = true;
      };
      home.sessionVariables.NIXOS_OZONE_WL = "1";
    };
    system-nixos = {
      programs.hyprland.enable = true;
    };
  }
