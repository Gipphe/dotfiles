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
  };
}
