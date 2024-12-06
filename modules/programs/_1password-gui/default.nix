{
  lib,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "_1password-gui";
  hm = lib.mkIf pkgs.stdenv.isLinux { home.packages = with pkgs; [ _1password-gui ]; };
  system-nixos.systemd.user.services._1password-boot = {
    wantedBy = [ "default.target" ];
    description = "Start 1password in the background.";
    serviceConfig.ExecStop = "${pkgs._1password-gui}/bin/1password --silent";
  };
  system-darwin.homebrew.casks = [ "1password" ];
}
