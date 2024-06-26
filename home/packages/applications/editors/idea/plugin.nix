{
  lib,
  pkgs,
  config,
  flags,
  ...
}@args:
let
  inherit (import ./utils.nix args) ideaDir;
  inherit (lib) hasSuffix pipe;
  inherit (pkgs) fetchzip stdenv;
  inherit (builtins) fetchurl listToAttrs;
  cfg = config.gipphe.programs.idea-ultimate;

  mkPluginEntry = id: plugin: {
    name = "${ideaDir}/${plugin.name}";
    value.source = mkPlugin id plugin;
  };

  fetchPluginSrc =
    url: hash:
    let
      isJar = hasSuffix ".jar" url;
      fetcher = if isJar then fetchurl else fetchzip;
    in
    fetcher {
      executable = isJar;
      inherit url hash;
    };

  mkPlugin =
    id: file:
    stdenv.mkDerivation {
      name = "jetbrains-plugin-${id}";
      installPhase = ''
        runHook preInstall
        mkdir -p $out && cp -r . $out
        runHook postInstall
      '';
      src = fetchPluginSrc file.url file.hash;
    };

  plugins = pipe cfg.plugins [
    (map (plugin: mkPluginEntry plugin.id plugin))
    listToAttrs
  ];
in
{
  config = lib.mkIf (cfg.enable && builtins.length cfg.plugins > 0 && flags.isNixos) {
    xdg.dataFile = plugins;
  };
}
