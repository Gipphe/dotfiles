{ lib, ... }:
{
  imports = [
    ./idea.nix
    ./config.nix
    ./plugin.nix
  ];
  options.gipphe.programs.idea-ultimate = {
    enable = lib.mkEnableOption "idea-ultimate";
    plugins = lib.mkOption {
      description = "Plugins to add";
      default = [
        {
          id = "1347-scala";
          name = "Scala";
          url = "https://plugins.jetbrains.com/files/1347/544339/scala-intellij-bin-2024.1.21.zip";
          hash = "sha256-X7gAfpzhnTOsz3z170ahZ1ddqMHND8+qMzoXU51R/S4=";
        }
        {
          id = "164-ideavim";
          name = "IdeaVim";
          url = "https://plugins.jetbrains.com/files/164/546759/IdeaVim-2.12.0-signed.zip";
          hash = "sha256-6ibo1vdwO4olQTCWpWAefT3QCwgtzTo1ojilDes8Rvg=";
        }
        {
          id = "18682-catppuccin-theme";
          name = "Catppuccin Theme";
          url = "https://plugins.jetbrains.com/files/18682/546280/Catppuccin_Theme-3.3.1.zip";
          hash = "sha256-AlxMNYxS84BvQalaj3o14zHEXONuRNE5EOaJO7kNqAQ=";
        }
        {
          id = "23029-catppuccin-icons";
          name = "Catppuccin Icons";
          url = "https://plugins.jetbrains.com/files/23029/542152/Catppuccin_Icons-1.5.0.zip";
          hash = "sha256-Mm3V0mlW59EJyCzr75dhKFsOfUPnsVnU+D26+sFAnQ4=";
        }
        {
          id = "12062-vscode-keymap";
          name = "VSCode Keymap";
          url = "https://plugins.jetbrains.com/files/12062/508223/keymap-vscode-241.14494.150.zip";
          hash = "sha256-LeQ5vi9PCJYmWNmT/sutWjSlwZaAYYuEljVJBYG2VpY=";
        }
      ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption {
              type = lib.types.str;
              description = "ID of the plugin";
            };
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the plugin";
            };
            url = lib.mkOption {
              type = lib.types.str;
              description = "URL of the plugin";
            };
            hash = lib.mkOption {
              type = lib.types.str;
              description = "Hash of the plugin file";
            };
          };
        }
      );
    };
  };
}
