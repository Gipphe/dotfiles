{
  config,
  pkgs,
  lib,
  util,
  ...
}:
util.mkModule {
  hm.gipphe.programs.code-cursor.settings = {
    "editor.fontFamily" = "FiraCode Nerd Font Mono";
    "editor.fontLigatures" = true;
    "window.commandCenter" = 1;
    "editor.formatOnSave" = true;
    "editor.lineNumbers" = "relative";
    "vim.useSystemClipboard" = true;
    "vim.hlsearch" = true;
    "vim.leader" = "<space>";
    "vim.smartRelativeLine" = true;
    "extensions.experimental.affinity" = {
      "vscode.vim" = 1;
    };
    "editor.cursorSurroundingLines" = 8;
    "vim.highlightedyank.enable" = true;
    "vim.highlightedyank.duration" = 150;
    "vim.highlightedyank.color" = "#a9dc7660";
    "vim.normalModeKeyBindings" = [
      {
        "before" = [
          "K"
        ];
        "commands" = [
          "editor.action.showHover"
        ];
      }
      {
        "before" = [
          "g"
          "p"
          "d"
        ];
        "commands" = [
          "editor.action.peekDefinition"
        ];
      }
      {
        "before" = [
          "g"
          "h"
        ];
        "commands" = [
          "editor.action.showDefinitionPreviewHover"
        ];
      }
      {
        "before" = [
          "g"
          "i"
        ];
        "commands" = [
          "editor.action.goToImplementation"
        ];
      }
      {
        "before" = [
          "g"
          "p"
          "i"
        ];
        "commands" = [
          "editor.action.peekImplementation"
        ];
      }
      {
        "before" = [
          "g"
          "q"
        ];
        "commands" = [
          "editor.action.quickFix"
        ];
      }
      {
        "before" = [
          "g"
          "r"
        ];
        "commands" = [
          "editor.action.referenceSearch.trigger"
        ];
      }
      {
        "before" = [
          "g"
          "t"
        ];
        "commands" = [
          "editor.action.goToTypeDefinition"
        ];
      }
      {
        "before" = [
          "g"
          "p"
          "t"
        ];
        "commands" = [
          "editor.action.peekTypeDefinition"
        ];
      }
      {
        "before" = [
          "<leader>"
          "e"
        ];
        "commands" = [
          "workbench.view.explorer"
        ];
      }
      {
        "before" = [
          "<leader>"
          "<leader>"
        ];
        "commands" = [
          "workbench.action.quickOpen"
        ];
      }
    ];
    "workbench.iconTheme" = "catppuccin-perfect-macchiato";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    "nix.enableLanguageServer" = true;
    "nix.formatterPath" = "${lib.getExe pkgs.nixfmt-rfc-style}";
    "nix.serverPath" = "${lib.getExe config.programs.nixvim.plugins.lsp.servers.nil_ls.package}";
  };
}
