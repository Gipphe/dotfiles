{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          dockerls.enable = true;
          eslint.enable = true;
          jsonls.enable = true;
          html.enable = true;
          # Uses haskell-tools instead
          # hls.enable = true;
          java-language-server.enable = true;
          lemminx.enable = true;
          lua-ls.enable = true;
          marksman.enable = true;
          # metals.enable = true;
          nil_ls.enable = true;
          pyright.enable = true;
          ruff-lsp.enable = true;
          sqls.enable = true;
          tailwindcss.enable = true;
          terraformls.enable = true;
          tsserver.enable = true;
          yamlls.enable = true;
        };
      };
      lsp-lines.enable = true;
      lspkind.enable = true;
    };
  };
}
