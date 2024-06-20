{
  pkgs,
  config,
  lib,
  flags,
  ...
}:
let
  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != [ ]) ''
      export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: ''
        export ${k}=${builtins.toString v}
      '') config.home.sessionVariables
    )}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';

  # runs processes as systemd transient services
  run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --slice=app-manual.slice \
      --property=ExitType=cgroup \
      --user \
      --wait \
      bash -lc "exec ${apply-hm-env} $@"
  '';
in
{
  options.gipphe.programs.run-as-service.enable = lib.mkEnableOption "run-as-service";
  config = lib.mkIf config.gipphe.programs.run-as-service.enable {
    home.packages = [
      (
        if flags.system.isNixDarwin then
          throw "run-as-service is not available on nix-darwin since darwin does not use systemd."
        else
          run-as-service
      )
    ];
  };
}
