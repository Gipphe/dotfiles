{
  programs.nixvim = {
    plugins.lsp.servers = {
      pyright.enable = true;
      ruff-lsp = {
        enable = true;
        onAttach.function = ''
          -- Disable hover in favour of Pyright
          client.server_capabilities.hoverProvider = false

          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
            })
          end, {buffer = true, desc = "Organize Imports", silent = true})
        '';
      };
    };
  };
}
