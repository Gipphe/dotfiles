{ util, ... }:
util.mkProgram {
  name = "skhd";
  system-darwin.services.skhd = {
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
