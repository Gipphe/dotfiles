{
  util,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.nushell;
  abbrsAsAliases = lib.mapAttrs (
    _: v: if builtins.isAttrs v then v.expansion else v
  ) config.gipphe.core.shell.abbrs;
  aliases = lib.mkMerge [
    abbrsAsAliases
    config.gipphe.core.shell.aliases
  ];
in
util.mkProgram {
  name = "nushell";
  options.gipphe.programs.nushell.default = lib.mkEnableOption "Nushell as default shell";
  homeManager = {
    options.gipphe.programs.nushell.package = lib.mkPackageOption pkgs "nushell" { } // {
      default = config.programs.nushell.package;
    };
    programs = {
      bash = lib.mkIf cfg.default {
        enable = true;
        initExtra = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]; then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${cfg.package}/bin/nu $LOGIN_OPTION
          fi
        '';
      };

      nushell = {
        enable = true;
        shellAliases = aliases // {
          rm = "rm -i";
        };
        settings = {
          edit_mode = "vim";
        };
      };
    };
  };
}
