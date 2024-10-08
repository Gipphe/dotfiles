{
  lib,
  config,
  util,
  ...
}:
let
  inherit (builtins) isString;
  inherit (import ./helpers.nix { inherit lib; })
    toPSValue
    mkRaw
    isRaw
    rawType
    ;
  cfg = config.gipphe.windows.environment;
  defaultEnvs = {
    XDG_CONFIG_HOME = mkRaw ''"$($Env:USERPROFILE)\\.config"'';
  };
  envs = lib.filterAttrs (_: v: v.enable) (
    lib.mapAttrs (
      name: value:
      if isString value || isRaw value then
        {
          enable = true;
          inherit value;
        }
      else
        value
    ) (cfg.variables // defaultEnvs)
  );
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
              enable = lib.mkOption {
                description = "Whether to set the environment variable or not.";
                type = bool;
                default = true;
              };
              value = lib.mkOption {
                description = "Value of the environment variable";
                type = oneOf [
                  str
                  rawType
                ];
              };
            };
          })
        ]);
      default = { };
    };
  };
  hm = lib.mkIf cfg.enable {
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
                ${
                  lib.pipe envs [
                    (lib.mapAttrsToList (name: val: "'${name}' = ${toPSValue val.value}"))
                    (lib.concatStringsSep ", ")
                  ]
                }
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
