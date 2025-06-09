{
  lib,
  config,
  pkgs,
  util,
  ...
}:
let
  script = util.writeFishApplication {
    name = "rofi-1password";
    runtimeInputs = with pkgs; [
      pinentry-rofi
      xdg-utils
    ];
    text = builtins.readFile ./1password.fish;
  };
  rofi-1p = pkgs.writeShellScriptBin "rofi-1pass" ''
    ${config.programs.rofi.package}/bin/rofi -modi 1pass:rofi-password -show 1pass
  '';
in
{
  config = lib.mkIf config.gipphe.programs._1password-cli.enable {
    home.packages = [
      script
      rofi-1p
    ];
    wayland.windowManager.hyprland.settings.bind = [
      "$mod, P, exec, ${rofi-1p}/bin/rofi-1pass"
    ];
  };
}
