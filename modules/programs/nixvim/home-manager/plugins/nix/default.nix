{
  programs.nixvim.plugins.lsp.servers = {
    nixd = {
      enable = true;
      onAttach.function = ''
        client.server_capabilities.semanticTokensProvider = nil
      '';
    };
    nil_ls.enable = true;
  };
}
