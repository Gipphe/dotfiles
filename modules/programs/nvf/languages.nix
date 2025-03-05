{ config, pkgs, ... }:
{
  programs.nvf.settings.vim.languages = {
    enableDAP = true;
    enableExtraDiagnostics = true;
    enableFormat = true;
    enableLSP = true;
    enableTreesitter = true;

    bash.enable = true;
    csharp.enable = !pkgs.stdenv.isDarwin;
    css.enable = true;
    css.format.type = "prettierd";
    go.enable = true;
    haskell.enable = true;
    html.enable = true;
    java.enable = true;
    lua.enable = true;
    markdown.enable = true;
    markdown.format.type = "prettierd";
    nix = {
      enable = true;
      format.type = "nixfmt";
      lsp.options = {
        nixpkgs.expr = "import <nixpkgs> { }";
        options.nixos.expr =
          let
            configType = if pkgs.stdenv.isDarwin then "darwinConfigurations" else "nixosConfigurations";
          in
          "(builtins.getFlake \"${config.home.sessionVariables.FLAKE}\").${configType}.${config.gipphe.hostName}.options";
      };
    };
    python.enable = true;
    python.format.type = "ruff";
    rust.enable = true;
    scala.enable = true;
    sql.enable = true;
    tailwind.enable = true;
    terraform.enable = true;
    ts = {
      enable = true;
      extensions.ts-error-translator.enable = true;
      format.type = "prettierd";
    };
  };
}
