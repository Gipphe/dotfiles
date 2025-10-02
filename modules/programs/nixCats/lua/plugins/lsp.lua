return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    dependencies = {
      {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        'williamboman/mason.nvim',
        -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
        -- because we will be using nix to download things instead.
        enabled = require('nixCatsUtils').lazyAdd(true, false),
        opts = {},
      }, -- NOTE: Must be loaded before dependants

      {
        'williamboman/mason-lspconfig.nvim',
        -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
        -- because we will be using nix to download things instead.
        enabled = require('nixCatsUtils').lazyAdd(true, false),
      },

      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
        -- because we will be using nix to download things instead.
        enabled = require('nixCatsUtils').lazyAdd(true, false),
      },
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        ---@type table See |fidget-options| or |fidget-option.txt|.
        opts = {},
      },
      'folke/lazydev.nvim',
      'lukahartwig/pnpm.nvim',
      -- Does not work correctly in Neovim v0.11 with vim.lsp.
      -- 'folke/neoconf.nvim',
      'saghen/blink.cmp',
    },
    opts = function(opts)
      opts = opts or {}

      -- lspconfig {{{
      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      -- NOTE: nixCats: there is help in nixCats for lsps at `:h nixCats.LSPs` and also `:h nixCats.luaUtils`
      --
      -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      -- }}}
      local servers = {
        -- 'basedpyright',
        'bashls',
        -- 'dockerls',
        'elmls',
        'jsonls',
        'html',
        -- 'qmlls',
        -- 'lemminx',
        'eslint',
        -- 'gopls',
        -- 'rust_analyzer',
        'tailwindcss',
        'fish_lsp',
        'terraformls',
        -- 'metals',
        'yamlls',
        -- 'sqls',
        'ts_ls',
        'marksman',
        'ruff',
        'lua_ls',
        'nil_ls',
      }

      if require('nixCatsUtils').isNixCats then
        -- NOTE: nixCats: nixd is not available on mason.
        -- Feel free to check the nixd docs for more configuration options:
        -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
        table.insert(servers, 'nixd')
        table.insert(servers, 'powershell_es')
      else
        table.insert(servers, 'rnix')
      end

      return vim.tbl_deep_extend('force', {}, opts, { servers = servers })
    end,

    config = function(_, opts)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          ---@param keys string
          ---@param func string|function
          ---@param desc string
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          -- Open LSP info
          map('<leader>cl', '<cmd>LspInfo<cr>', 'Lsp info')

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          map('gd', function()
            require('snacks').picker.lsp_definitions { reuse_win = true }
          end, 'Goto definition')

          map('gr', function()
            require('snacks').picker.lsp_references()
          end, 'Goto references')

          map('gD', function()
            vim.lsp.buf.declaration()
          end, 'Goto declaration')

          map('gI', function()
            require('snacks').picker.lsp_implementations { reuse_win = true }
          end, 'Goto implementation')

          map('gy', function()
            require('snacks').picker.lsp_type_definitions { reuse_win = true }
          end, 'Goto type definition')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', function()
            vim.lsp.buf.hover { border = 'rounded' }
          end, 'Hover documentation')

          map('gK', function()
            vim.lsp.buf.signature_help { border = 'rounded' }
          end, 'Signature help')

          vim.keymap.set('i', '<C-k>', function()
            vim.lsp.buf.signature_help { border = 'rounded' }
          end, { desc = 'Signature help', buffer = event.buf })

          vim.keymap.set({ 'n', 'v' }, '<leader>ca', function()
            vim.lsp.buf.code_action { border = 'rounded' }
          end, { desc = 'Code action', buffer = event.buf })

          vim.keymap.set({ 'n', 'v' }, '<leader>cc', vim.lsp.codelens.run, { desc = 'Run codelens', buffer = event.buf })
          vim.keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh, { desc = 'Refresh & display codelens', buffer = event.buf })
          vim.keymap.set('n', '<leader>cA', function()
            vim.lsp.buf.code_action {
              context = {
                only = { 'source' },
                diagnostics = {},
              },
              border = 'rounded',
            }
          end, { desc = 'Source action', buffer = event.buf })

          vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = event.buf })

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          -- vim.keymap.set('n', '<leader>cy', require('snacks').picker.lsp_document_symbols, { desc = 'Document symbols', buffer = event.buf })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          -- vim.keymap.set('n', '<leader>cY', require('snacks').picker.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols', buffer = event.buf })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', function()
            vim.lsp.buf.declaration { border = 'rounded' }
          end, 'Goto declaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- TODO Superseded by vim-illuminate
          -- if client and client.server_capabilities.documentHighlightProvider then
          --   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.document_highlight,
          --   })
          --
          --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.clear_references,
          --   })
          --
          --   vim.api.nvim_create_autocmd('LspDetach', {
          --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          --     callback = function(event2)
          --       vim.lsp.buf.clear_references()
          --       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          --     end,
          --   })
          -- end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>cth', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, 'Toggle inlay hints')
          end
        end,
      })

      local severity = vim.diagnostic.severity
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [severity.ERROR] = '󰅚 ',
            [severity.WARN] = '󰀪 ',
            [severity.INFO] = '󰋽 ',
            [severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [severity.ERROR] = diagnostic.message,
              [severity.WARN] = diagnostic.message,
              [severity.INFO] = diagnostic.message,
              [severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      vim.lsp.config('*', { capabilities = capabilities })
      local servers = opts.servers

      -- NOTE: nixCats: if nix, use vim.lsp instead of mason
      -- You could MAKE it work, using lspsAndRuntimeDeps and sharedLibraries in nixCats
      -- but don't... its not worth it. Just add the lsp to lspsAndRuntimeDeps.
      if require('nixCatsUtils').isNixCats then
        vim.lsp.enable(servers)
        -- for server_name, cfg in pairs(servers) do
        --   -- vim.lsp.config(server_name, cfg)
        --   -- vim.lsp.enable(server_name)
        --   require('lspconfig')[server_name].setup(cfg)
        -- end
      else
        -- NOTE: nixCats: and if no nix, do it the normal way

        -- Ensure the servers and tools above are installed
        --  To check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :Mason
        --
        --  You can press `g?` for help in this menu.
        require('mason').setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = servers
        vim.fn.extendnew(ensure_installed, {
          'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          ensure_installed = {},
          automatic_enable = true,
        }
      end
    end,
  },

  -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  {
    'folke/lazydev.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    dependencies = {
      {
        'saghen/blink.cmp',
        opts = {
          sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
              lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
              },
            },
          },
        },
      },
    },
    ft = 'lua',
    ---@module 'lazydev'
    ---@type lazydev.Config
    opts = {
      library = {
        -- adds type hints for nixCats global
        { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'mrcjkb/haskell-tools.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'haskell',
    version = '^6',
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('haskell-tools', { clear = true }),
        pattern = { 'haskell' },
        callback = function(buffer)
          local ht = require 'haskell-tools'
          local lmap = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, {
              noremap = true,
              silent = true,
              buffer = buffer.buf,
              desc = desc,
            })
          end
          lmap('n', '<leader>cl', vim.lsp.codelens.run, 'Run codelens')
          lmap('n', '<leader>chs', ht.hoogle.hoogle_signature, 'Hoogle search type signature under cursor')
          lmap('n', '<leader>cea', ht.lsp.buf_eval_all, 'Evaluate all code snippets')
          lmap('n', '<leader>cpr', ht.repl.toggle, 'Toggle GHCi repl for the current package')
          lmap('n', '<leader>cpR', function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
          end, 'Toggle GHCi repl for current buffer')
          lmap('n', '<leader>cpq', ht.repl.quit, 'Close GHCi repl')
        end,
      })
    end,
    ft = { 'haskell' },
  },

  -- {
  --   'kiyoon/haskell-scope-highlighting.nvim',
  --   enabled = require('nixCatsUtils').enableForCategory 'haskell',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   init = function()
  --     vim.cmd [[autocmd FileType haskell syntax off]]
  --     vim.cmd [[autocmd FileType haskell TSDisable highlight]]
  --   end,
  -- },

  {
    'jmbuhr/otter.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      handle_leading_whitespace = true,
    },
  },

  {
    'elkowar/yuck.vim',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    ft = { 'yuck' },
  },

  {
    'lukahartwig/pnpm.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    ft = { 'js', 'ts', 'tsx', 'jsx' },
  },
}
