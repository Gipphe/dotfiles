{ helpers, ... }:
{
  plugins = {
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp = {
      enable = true;
      settings = {
        completion = {
          completeopt = "menu,menuone,noinsert";
        };
        mapping = helpers.raw ''
          cmp.mapping.preset.insert({
              ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
              ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              ["<S-CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              }),
              ["<C-CR>"] = function(fallback)
                cmp.abort()
                fallback()
              end,
            })
        '';
        sources = helpers.raw ''
          cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'path' },
          }, {
            { name = 'buffer' },
          })
        '';
        experimental.ghost_text.hl_group = "CmpGhostText";
      };
    };
  };
}
