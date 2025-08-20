return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
    {
      '<leader>cF',
      function()
        require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
      end,
      mode = { 'n', 'v' },
      desc = 'Format injected langs',
    },
  },
  opts = function()
    local prettier = { 'prettierd', 'prettier', stop_after_first = true }
    return {
      notify_on_error = true,
      notify_no_formatters = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        ['markdown.mdx'] = prettier,
        cabal = { 'cabal_fmt' },
        css = prettier,
        fish = { 'fish_indent' },
        graphql = prettier,
        handlebars = prettier,
        haskell = { 'fourmolu' },
        html = prettier,
        javascript = prettier,
        javascriptreact = prettier,
        json = prettier,
        jsonc = prettier,
        less = prettier,
        lua = { 'stylua' },
        markdown = prettier,
        nix = { 'nixfmt' },
        python = { 'ruff_format', 'ruff_organize_imports' },
        scss = prettier,
        sh = { 'shfmt' },
        terraform = { 'tofu_fmt' },
        typescript = prettier,
        typescriptreact = prettier,
        vue = prettier,
        yaml = prettier,
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = true,
          },
        },
      },
      format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
      },
    }
  end,
}
