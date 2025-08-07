{
  lib,
  flags,
  config,
  pkgs,
  util,
  ...
}:
let
  inherit (lib) concatStringsSep toString;
  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != [ ]) ''
      export PATH=${concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: ''
        export ${k}=${toString v}
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
util.mkProgram {
  name = "run-as-service";
  hm = lib.mkIf (!flags.isNixDarwin) { home.packages = [ run-as-service ]; };
}
