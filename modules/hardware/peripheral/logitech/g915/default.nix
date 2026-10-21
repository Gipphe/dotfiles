{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  noctalia = "${lib.getExe' config.programs.noctalia.package "noctalia"} msg";
in
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g915";
  homeManager = {
    gipphe.core.wm.bind = {
      "XF86AudioPlay".action.spawn = "${noctalia} media toggle";
      "XF86AudioPrev".action.spawn = "${noctalia} media previous";
      "XF86AudioNext".action.spawn = "${noctalia} media next";
    };
  };
  nixos = {
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
    # Solaar drives the G915 lighting (per-key colors, idle dim, sleep). Keep
    # OpenRGB, if enabled by other devices, from grabbing the keyboard and
    # fighting Solaar over it.
    systemd.services.openrgb.preStart = lib.mkIf config.services.hardware.openrgb.enable ''
      config=/var/lib/OpenRGB/OpenRGB.json
      [ -s "$config" ] || echo '{}' > "$config"
      ${lib.getExe pkgs.jq} '
        .Detectors.detectors += {
          "Logitech G915 Wireless RGB Mechanical Gaming Keyboard": false,
          "Logitech G915 Wireless RGB Mechanical Gaming Keyboard (Receiver 2)": false,
          "Logitech G915 Wireless RGB Mechanical Gaming Keyboard (Wired)": false
        }
      ' "$config" > "$config.tmp"
      mv "$config.tmp" "$config"
    '';
  };
}
