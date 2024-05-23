{
  programs.nixvim = {
    plugins.lsp.server = {
      pyright.enable = true;
      ruff-lsp = {
        enable = true;
        onAttach.function = ''
          function(client, bufnr)
            -- Disable hover in favour of Pyright
            client.server_capabilities.hoverProvider = false
            nvim_buf_set_keymap("n", "<leader>co", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports" },
                  diagnostics = {},
                },
              })
            end, {desc = "Organize Imports", silent = true})
          end
        '';
      };
    };
  };
}
