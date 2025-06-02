{ util, pkgs, ... }:
let
  grimblast = pkgs.makeExe pkgs.grimblast;
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
    )
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
    )
  );
in
util.mkToggledModule
  [
    "environment"
    "desktop"
  ]
  {
    name = "hyprland";
    hm = {
      programs.kitty.enable = true;
      wayland.windowManager.hyprland = {
        enable = true;
        # settings = {
        #   "$mod" = "Super";
        #   bind = workspaces ++ [
        #     "$mod, F, exec, floorp"
        #     ", Print, exec, ${grimblast} copy area"
        #   ];
        # };
        # xwayland.enable = true;
      };
      # home.sessionVariables.NIXOS_OZONE_WL = "1";
      # programs = {
      #   hyprlock.enable = true;
      #   waybar.enable = true;
      # };
      # services = {
      #   hypridle.enable = true;
      #   hyprpaper.enable = true;
      #   mako.enable = true;
      # };
    };
    system-nixos = {
      programs.hyprland.enable = true;
      # security.pam.services.hyprlock = { };
    };
  }
