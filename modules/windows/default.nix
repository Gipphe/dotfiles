{
  self,
  util,
  lib,
  pkgs,
  ...
}:
util.mkModule {
  hm.home.activation = lib.mapAttrs' (
    hostname: cfg:
    let
      destPath = "projects/dotfiles/windows/configurations/${hostname}.json";
      pkg = pkgs.writeText "windows-configuration-${cfg.hostname}" (
        builtins.toJSON cfg.windows.configuration
      );
    in
    {
      name = "write-windows-configuration-${hostname}";
      value = lib.hm.dag.entryAfter [ "onFilesChange" ] ''
        run mkdir -p $(dirname -- '${destPath}')
        run cp -f '${pkg}' '${destPath}'
      '';
    }
  ) self.windowsConfigurations.${pkgs.system};
}
