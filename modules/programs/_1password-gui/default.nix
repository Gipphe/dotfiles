{
  lib,
  pkgs,
  util,
  ...
}:
let
  quick-access = pkgs.writeShellScriptBin "1password-quick-access" ''
    ${pkgs._1password-gui}/bin/1password --quick-access
  '';
in
util.mkProgram {
  name = "_1password-gui";
  hm = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = with pkgs; [ _1password-gui ];
    wayland.windowManager.hyprland.settings.bind = [
      "CONTROL SHIFT,SPACE,exec,${quick-access}/bin/1password-quick-access"
    ];
  };
  system-nixos.systemd.user.services._1password-boot = {
    wantedBy = [ "default.target" ];
    description = "Start 1password in the background.";
    serviceConfig.ExecStop = "${pkgs._1password-gui}/bin/1password --silent";
  };
  system-darwin.homebrew.casks = [ "1password" ];
}
