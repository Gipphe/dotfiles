{
  programs.nixvim.plugins = {
    lsp.servers.marksman.enable = true;
    none-ls.sources.diagnostics.markdownlint_cli2.enable = true;
  };
}
