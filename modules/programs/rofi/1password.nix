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
      pinentry-gtk2
      xdg-utils
      _1password-cli
      coreutils
      jq
    ];
    text = builtins.readFile ./1password.fish;
  };
  rofi-1p = pkgs.writeShellScriptBin "rofi-1pass" ''
    ${config.programs.rofi.package}/bin/rofi -modi 1pass:${script}/bin/rofi-1password -show 1pass
  '';
in
{
  config = lib.mkIf config.gipphe.programs._1password-cli.enable {
    home.packages = [
      script
      rofi-1p
    ];
    gipphe.core.wm.binds = [
      {
        mod = [
          "Mod"
          "SHIFT"
        ];
        key = "P";
        action.spawn = "${rofi-1p}/bin/rofi-1pass";
      }
    ];
  };
}
