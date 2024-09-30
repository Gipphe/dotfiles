{ util, ... }:
util.mkProgram {
  name = "yabai";
  # environment.etc."sudoers.d/yabai".text =
  #   let
  #     yabai = config.services.yabai.package;
  #     hash = builtins.hashFile "sha256" "${yabai}/bin/yabai";
  #   in
  #   ''
  #     ${username} ALL=(root) NOPASSWD: sha256:${hash} ${yabai} --load-sa
  #   '';
  system-darwin.services.yabai = {
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
  };
}
