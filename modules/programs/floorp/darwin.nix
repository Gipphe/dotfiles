{
  config,
  lib,
  pkgs,
  util,
  ...
}:
let
  cfg = config.gipphe.programs.floorp;
in
util.mkModule {
  hm = (
    lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isDarwin) {
      home.packages = [
        (pkgs.writeShellScriptBin "floorp" ''
          MOZ_LEGACY_PROFILES=1 open -na "Floorp.app"
        '')
      ];
    }
  );
  system-darwin = lib.mkIf cfg.enable { homebrew.casks = [ "floorp" ]; };
}
