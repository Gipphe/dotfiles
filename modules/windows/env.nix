{
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.windows.environment;
  defaultEnvs = {
    HOME = "$Env:USERPROFILE";
    XDG_CONFIG_HOME = "$Env:USERPROFILE/.config";
  };
  envs = lib.filterAttrs (_: v: v.enable) cfg.variables;
  order = import ./order.nix;
in
util.mkToggledModule [ "windows" ] {
  name = "environment";
  options.gipphe.windows.environment = {
    variables = lib.mkOption {
      description = "Environment variables";
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          (submodule {
            options = {
              value = lib.mkOption {
                description = "Value of the environment variable";
                type = str;
              };
              enable = lib.mkOption {
                description = "Whether to set the environment variable or not.";
                type = bool;
                default = true;
              };
            };
          })
        ]);
      default = defaultEnvs;
    };
  };
  hm = lib.mkIf (envs != { }) {
    gipphe.windows.powershell-script =
      lib.mkOrder order.env # powershell
        ''
          class Env {
            [PSCustomObject]$Logger
            
            Env([PSCustomObject]$Logger) {
              $this.Logger = $Logger
            }
            [Void] Install() {
              $this.Logger.Info(" Setting env vars...")
              $ChildLogger = $this.Logger.ChildLogger()
              $EnvVars = @{
                'HOME' = $Env:USERPROFILE
                'XDG_CONFIG_HOME' = "$Env:USERPROFILE/.config"
              }
              $EnvVars.GetEnumerator() | ForEach-Object {
                $key = $_.Key
                $val = $_.Value
                [Environment]::SetEnvironmentVariable($key, $val, 'User')
                $ChildLogger.Info(" $key env var set")
              }
              $this.Logger.Info(" Env vars set.")
            }
          }
          $Env = [Env]::new($Logger)
          $Env.Install()
        '';
  };
}
