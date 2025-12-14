{
  lib,
  util,
  pkgs,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.quickshell;
in
util.mkProgram {
  name = "quickshell";
  options.gipphe.programs.quickshell = {
    dev = lib.mkEnableOption "dev config";
    configPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to config files";
      default = ./config;
      defaultText = "<nix-store-path>";
      internal = true;
    };
  };
  hm = {
    options.gipphe.programs.quickshell.package = lib.mkPackageOption pkgs "quickshell" { };
    config = lib.mkMerge [
      (lib.mkIf cfg.dev {
        gipphe.programs.quickshell.configPath = "${config.gipphe.homeDirectory}/projects/dotfiles/modules/programs/quickshell/config";
      })
      {
        home.packages = [ cfg.package ];
        xdg.configFile."quickshell".source = ./config;
        systemd.user.services.quickshell = {
          Unit = {
            Description = "quickshell";
            Documentation = "https://quickshell.outfoxxed.me/docs/";
            After = [ config.wayland.systemd.target ];
          };
          Service = {
            ExecStart = "${lib.getExe cfg.package} -p ${cfg.configPath}";
            Restart = "on-failure";
          };
          Install.WantedBy = [ config.wayland.systemd.target ];
        };
      }
    ];
  };
}
