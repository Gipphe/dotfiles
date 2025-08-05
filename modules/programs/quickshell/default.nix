{
  lib,
  util,
  inputs,
  pkgs,
  config,
  ...
}:
let
  pkg = inputs.quickshell.packages.${pkgs.system}.default;
in
util.mkProgram {
  name = "quickshell";
  hm = {
    home.packages = [ pkg ];
    xdg.configFile."quickshell".source = ./config;
    systemd.user.services.quickshell = {
      Unit = {
        Description = "quickshell";
        Documentation = "https://quickshell.outfoxxed.me/docs/";
        After = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${lib.getExe pkg} -p ${config.gipphe.homeDirectory}/projects/dotfiles/modules/programs/quickshell/config";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
