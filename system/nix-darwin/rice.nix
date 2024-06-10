# { config, username, ... }:
{
  # environment.etc."sudoers.d/yabai".text =
  #   let
  #     yabai = config.services.yabai.package;
  #     hash = builtins.hashFile "sha256" "${yabai}/bin/yabai";
  #   in
  #   ''
  #     ${username} ALL=(root) NOPASSWD: sha256:${hash} ${yabai} --load-sa
  #   '';
  system.defaults = {
    # ".GlobalPreferences"."com.apple.mouse.scaling" = 1;
    CustomUserPreferences = {
      "com.apple.dock"."workspaces-swoosh-animation-off" = true;
    };
  };
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "float";
      window_gap = 5;
      window_shadow = "float";
      window_opacity = "on";
      active_window_opacity = 1.0;
      normal_window_opacity = 1.0;
    };
    # extraConfig = ''
    #   yabai -m rule --add app="IntelliJ IDEA" manage=off
    #   yabai -m rule --add app="IntelliJ IDEA" title=".*\[(.*)\].*" manage=on
    # '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # float / unfloat window and center on screen
      cmd + alt - t : yabai -m window --toggle float; \
                      yabai -m window --grid 4:4:1:1:2:2

      alt - t : yabai -m window --toggle float; \
                yabai -m window --grid 20:20:1:1:18:18

      # change layout
      ctrl + alt - z : yabai -m space --layout bsp
      ctrl + alt - x : yabai -m space --layout float
    '';
  };
}
