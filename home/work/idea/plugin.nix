{ lib, pkgs, ... }@args:
let
  inherit (import ./paths.nix args) ideaDir;
  inherit (lib) hasSuffix pipe mapAttrsToList;
  inherit (pkgs) fetchzip stdenv;
  inherit (builtins) fetchurl listToAttrs;
  rawPlugins = {
    "1347-scala" = {
      name = "Scala";
      url = "https://plugins.jetbrains.com/files/1347/544339/scala-intellij-bin-2024.1.21.zip";
      hash = "sha256-X7gAfpzhnTOsz3z170ahZ1ddqMHND8+qMzoXU51R/S4=";
    };
    "164-ideavim" = {
      name = "IdeaVim";
      url = "https://plugins.jetbrains.com/files/164/546759/IdeaVim-2.12.0-signed.zip";
      hash = "sha256-X7gAfpzhnTOsz3z170ahZ1ddqMHND8+qMzoXU51R/S4=";
    };
    "18682-catppuccin-theme" = {
      name = "Catppuccin Theme";
      url = "https://plugins.jetbrains.com/files/18682/546280/Catppuccin_Theme-3.3.1.zip";
      hash = "sha256-Mm3V0mlW59EJyCzr75dhKFsOfUPnsVnU+D26+sFAnQ4=";
    };
    "23029-catppuccin-icons" = {
      name = "Catppuccin Icons";
      url = "https://plugins.jetbrains.com/files/23029/542152/Catppuccin_Icons-1.5.0.zip";
      hash = "sha256-Mm3V0mlW59EJyCzr75dhKFsOfUPnsVnU+D26+sFAnQ4=";
    };
    "12062-vscode-keymap" = {
      name = "VSCode Keymap";
      url = "https://plugins.jetbrains.com/files/12062/508223/keymap-vscode-241.14494.150.zip";
      hash = "sha256-LeQ5vi9PCJYmWNmT/sutWjSlwZaAYYuEljVJBYG2VpY=";
    };
  };

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

  plugins = pipe rawPlugins [
    (mapAttrsToList (key: val: mkPluginEntry key val))
    listToAttrs
  ];
in
{
  options.programs.idea-ultimate = {
    enable = lib.mkEnableOption "IntelliJ IDEA Ultimate";
    plugins = lib.mkOption {
      description = "Plugins to add";
      default = [ ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            id = lib.types.str;
            name = lib.types.str;
            url = lib.types.str;
            hash = lib.types.str;
          };
        }
      );
    };
  };
  config = {
    inherit plugins;
  };
}
