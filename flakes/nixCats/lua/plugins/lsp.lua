return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      {
        'williamboman/mason.nvim',
        -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
        -- because we will be using nix to download things instead.
        enabled = require('nixCatsUtils').lazyAdd(true, false),
        config = true,
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

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      {
        'folke/lazydev.nvim',
        dependencies = {
          {
            'hrsh7th/nvim-cmp',
            opts = function(_, opts)
              opts.sources = opts.sources or {}
              table.insert(opts.sources, {
                name = 'lazydev',
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
              })
            end,
          },
        },
        ft = 'lua',
        ---@type lazydev.Config
        opts = {
          library = {
            -- adds type hints for nixCats global
            { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
      -- kickstart.nvim was still on neodev. lazydev is the new version of neodev

      {
        'lukahartwig/pnpm.nvim',
        ft = { 'js', 'ts', 'tsx', 'jsx' },
        config = function()
          require('telescope').load_extension 'pnpm'
        end,
      },

      {
        'SmiteshP/nvim-navbuddy',
        enabled = require('nixCatsUtils').enableForCategory 'ui',
        dependencies = {
          'SmiteshP/nvim-navic',
          'MunifTanjim/nui.nvim',
        },
        opts = {
          lsp = {
            auto_attach = true,
          },
        },
        keys = {
          { '<leader>cn', '<cmd>Navbuddy<cr>', desc = 'Open Navbuddy' },
        },
      },

      'folke/neoconf.nvim',

      {
        'kevinhwang91/nvim-ufo',
        dependencies = {
          'kevinhwang91/promise-async',
        },
        config = false,
        keys = {
          {
            'zR',
            function()
              require('ufo').openAllFolds()
            end,
            desc = 'Open all folds',
          },
          {
            'zM',
            function()
              require('ufo').closeAllFolds()
            end,
            desc = 'Close all folds',
          },
        },
      },

      -- TODO Add cmp_nvim_lsp to deps list here
    },
    opts = {
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
      ---@type { [string]: lspconfig.Config }
      servers = {
        basedpyright = {
          enabled = require('nixCats').enableForCategory 'basedpyright',
        },
        bashls = {},
        dockerls = {},
        jsonls = {},
        html = {},
        java_language_server = {},
        lemminx = {},
        eslint = {},
        gopls = {},
        rust_analyzer = {},
        tailwindcss = {},
        fish_lsp = {},
        terraformls = {
          cmd = { 'opentofu-ls', 'serve' },
        },
        metals = {},
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
        },
        sqls = {},
        ts_ls = {
          on_attach = function()
            vim.keymap.set('n', '<leader>cw', function()
              require('telescope').extensions.pnpm.workspace()
            end, { buffer = true, desc = 'Select pnpm workspace', silent = true })
          end,
        },
        -- TODO Using haskell-tools instead
        -- hls = {
        --   filetypes = { 'haskell', 'lhaskell', 'cabal' },
        --   settings = {
        --     cabalFormattingProvider = 'cabalfmt',
        --     formattingProvider = 'fourmolu',
        --   },
        -- }
        marksman = {},
        ruff = {
          on_attach = function(client)
            -- Disable hover in favour of Pyright
            if require('nixCats').enableForCategory 'basedpyright' then
              client.server_capabilities.hoverProvider = false
            end
            vim.keymap.set('n', '<leader>co', function()
              vim.lsp.buf.code_action {
                apply = true,
                context = {
                  only = { 'source.organizeImports' },
                  diagnostics = {},
                },
              }
            end, { buffer = true, desc = 'Organize imports', silent = true })
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = {
                globals = { 'nixCats' },
                disable = { 'missing-fields' },
              },
            },
          },
        },

        -- NOTE: nixCats: nixd is not available on mason.
        -- Feel free to check the nixd docs for more configuration options:
        -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
        nixd = {
          enabled = require('nixCatsUtils').isNixCats,
          settings = {
            nixpkgs = {
              expr = nixCats.extra 'nixd.nixpkgs' or 'import <nixpkgs> { }',
            },
            formatting = {
              command = { 'nixfmt' },
            },
            options = {
              nixos = {
                expr = nixCats.extra 'nixd.nixos_options',
              },
              darwin = {
                expr = nixCats.extra 'nixd.darwin_options',
              },
              droid = {
                expr = nixCats.extra 'nixd.droid_options',
              },
            },
          },
        },
        rnix = {
          enabled = not require('nixCatsUtils').isNixCats,
        },
        nil_ls = {
          enabled = not require('nixCatsUtils').isNixCats,
        },
      },
    },
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
            require('telescope.builtin').lsp_definitions { reuse_win = true }
          end, 'Goto definition')

          map('gr', '<cmd>Telescope lsp_references<cr>', 'Goto references')

          map('gD', vim.lsp.buf.declaration, 'Goto declaration')

          map('gI', function()
            require('telescope.builtin').lsp_implementations { reuse_win = true }
          end, 'Goto implementation')

          map('gy', function()
            require('telescope.builtin').lsp_type_definitions { reuse_win = true }
          end, 'Goto type definition')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover documentation')

          map('gK', vim.lsp.buf.signature_help, 'Signature help')

          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = true })

          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action', buffer = true })

          vim.keymap.set({ 'n', 'v' }, '<leader>cc', vim.lsp.codelens.run, { desc = 'Run codelens', buffer = true })
          vim.keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh, { desc = 'Refresh & display codelens', buffer = true })
          vim.keymap.set('n', '<leader>cA', function()
            vim.lsp.buf.code_action { context = { only = { 'source' }, diagnostics = {} } }
          end, { desc = 'Source action', buffer = true })

          vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = true })

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', '<leader>cy', require('telescope.builtin').lsp_document_symbols, { desc = 'Document symbols', buffer = true })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', '<leader>cY', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols', buffer = true })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

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
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = opts.servers

      -- NOTE: nixCats: if nix, use lspconfig instead of mason
      -- You could MAKE it work, using lspsAndRuntimeDeps and sharedLibraries in nixCats
      -- but don't... its not worth it. Just add the lsp to lspsAndRuntimeDeps.
      if require('nixCatsUtils').isNixCats then
        for server_name, _ in pairs(servers) do
          local server = servers[server_name] or {}
          if server.enabled == nil or server.enabled == true then
            require('lspconfig')[server_name].setup {
              capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
              settings = server.settings,
              filetypes = server.filetypes,
              cmd = server.cmd,
              root_pattern = server.root_pattern,
            }
          end
        end
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
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              if server.enabled == nil or server.enabled == true then
                -- This handles overriding only values explicitly passed
                -- by the server configuration above. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for tsserver)
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                require('lspconfig')[server_name].setup(server)
              end
            end,
          },
        }
      end

      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup()
    end,
  },

  {
    'mrcjkb/haskell-tools.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'haskell',
    version = '^4',
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

  {
    'kiyoon/haskell-scope-highlighting.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'haskell',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function()
      vim.cmd [[autocmd FileType haskell syntax off]]
      vim.cmd [[autocmd FileType haskell TSDisable highlight]]
    end,
  },

  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      handle_leading_whitespace = true,
    },
  },

  -- TODO Are LSPs good enough?
  -- {
  --   'mfussenegger/nvim-lint',
  --   config = function()
  --     require('lint').linters_by_ft = {
  --       fish = { 'fish' },
  --     }
  --     vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  --       callback = function()
  --         require('lint').try_lint()
  --       end,
  --     })
  --   end,
  -- },
}
