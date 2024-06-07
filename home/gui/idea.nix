{ lib, pkgs, ... }:
let
  rawPlugins = {
    "1347-scala" = {
      url = "https://plugins.jetbrains.com/files/1347/544339/scala-intellij-bin-2024.1.21.zip";
      hash = "sha256-6ibo1vdwO4olQTCWpWAefT3QCwgtzTo1ojilDes8Rvg=";
    };
    "164-ideavim" = {
      url = "https://plugins.jetbrains.com/files/164/546759/IdeaVim-2.12.0-signed.zip";
      hash = "sha256-X7gAfpzhnTOsz3z170ahZ1ddqMHND8+qMzoXU51R/S4=";
    };
    "18682-catppuccin-theme" = {
      url = "https://plugins.jetbrains.com/files/18682/546280/Catppuccin_Theme-3.3.1.zip";
      hash = "sha256-Mm3V0mlW59EJyCzr75dhKFsOfUPnsVnU+D26+sFAnQ4=";
    };
    "23029-catppuccin-icons" = {
      url = "https://plugins.jetbrains.com/files/23029/542152/Catppuccin_Icons-1.5.0.zip";
      hash = "sha256-AlxMNYxS84BvQalaj3o14zHEXONuRNE5EOaJO7kNqAQ=";
    };
    "12062-vscode-keymap" = {
      url = "https://plugins.jetbrains.com/files/12062/508223/keymap-vscode-241.14494.150.zip";
      hash = "sha256-LeQ5vi9PCJYmWNmT/sutWjSlwZaAYYuEljVJBYG2VpY=";
    };
  };

  plugins = builtins.attrValues (lib.mapAttrs (key: val: mkPlugin key val) rawPlugins);

  fetchPluginSrc =
    url: hash:
    let
      isJar = lib.hasSuffix ".jar" url;
      fetcher = if isJar then builtins.fetchurl else pkgs.fetchzip;
    in
    fetcher {
      executable = isJar;
      inherit url hash;
    };

  mkPlugin =
    name: file:
    pkgs.stdenv.mkDerivation {
      name = "jetbrains-plugin-${name}";
      installPhase = ''
        runHook preInstall
        mkdir -p $out && cp -r . $out
        runHook postInstall
      '';
      src = fetchPluginSrc file.url file.hash;
    };
in
{
  home.packages = with pkgs; [ (jetbrains.plugins.addPlugins jetbrains.idea-ultimate plugins) ];
  home = {
    file.".ideavimrc".text = ''
      set number
      set relativenumber
    '';
  };
  programs.fish.shellAbbrs.idea = "idea-ultimate";
}
