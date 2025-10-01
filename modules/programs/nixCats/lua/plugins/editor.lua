local util = require 'util'

return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'folke/trouble.nvim',
    },
    -- TODO Figure out whether I need this. Keys conflict with bundled Telescope bindings.
    enable = false,
    opts = {},
    keys = {
      {
        '<leader>sr',
        function()
          require('spectre').open()
        end,
        desc = 'Replace in files (Spectre)',
      },
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      { 's', require('flash').jump, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
      { 'S', require('flash').treesitter, mode = { 'n', 'x', 'o' }, desc = 'Flash treesitter' },
      { 'r', require('flash').remote, mode = 'o', desc = 'Remote flash' },
      { 'R', require('flash').treesitter_search, desc = 'Treesitter search' },
      { '<C-s>', require('flash').toggle, mode = 'c', desc = 'Toggle flash search' },
    },
  },

  {
    'linux-cultist/venv-selector.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'folke/snacks.nvim',
    },
    lazy = false,
    branch = require('nixCatsUtils').isNixCats or 'regexp',
    ---@module 'venv-selector'
    ---@type venv-selector.Config
    opts = {
      options = {
        picker = 'snacks',
      },
    },
    keys = {
      { '<leader>cv', '<cmd>VenvSelect<cr>', desc = 'Select VirtualEnv' },
    },
  },

  {
    'cbochs/grapple.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    opts = { scope = 'git' },
    keys = {
      {
        '<leader>a',
        function()
          require('grapple').toggle()
          vim.notify('Tagged in Grapple', vim.log.levels.INFO)
        end,
        desc = 'Tag a file Grapple',
      },
      {
        '<C-e>',
        '<cmd>Grapple toggle_tags<cr>',
        desc = 'Toggle tags menu',
      },
      {
        '<leader>p',
        '<cmd>Grapple cycle_tags prev<cr>',
        desc = 'Go to previous tag',
      },
      {
        '<leader>n',
        '<cmd>Grapple cycle_tags next<cr>',
        desc = 'Go to next tag',
      },
    },
  },

  {
    'aca/marp.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    main = 'marp.nvim',
    version = false,
    dependencies = {
      {
        'folke/which-key.nvim',
        opts = {
          { '<leader>m', group = 'Marp' },
        },
      },
    },
    keys = {
      {
        '<leader>mpo',
        function()
          require('marp.nvim').ServerStart()
        end,
        desc = 'Start Marp server',
      },
      {
        '<leader>mpc',
        function()
          require('marp.nvim').ServerStop()
        end,
        desc = 'Stop Marp server',
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = vim.api.nvim_create_augroup('marp', { clear = true }),
        callback = function()
          require('marp.nvim').ServerStop()
        end,
      })
    end,
  },

  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    ---@module 'oil'
    ---@type oil.setupOpts
    opts = {
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<C-n>'] = 'actions.select_split',
        ['<C-m>'] = 'actions.refresh',
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          local always_hidden = {
            ['.git'] = true,
            ['.jj'] = true,
            ['.direnv'] = true,
            ['.DS_Store'] = true,
          }
          return always_hidden[name] ~= nil
        end,
      },
    },
    keys = {
      { '<leader>fe', '<cmd>Oil<cr>', desc = 'Open Oil (parent dir)' },
      { '<leader>fE', '<cmd>Oil .<cr>', desc = 'Open Oil (cwd)' },
      { '<leader>e', '<leader>fe', desc = 'Open Oil (parent dir)', remap = true },
      { '<leader>E', '<leader>fE', desc = 'Open Oil (cwd)', remap = true },
    },
  },

  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      {
        '<leader>qs',
        require('persistence').load,
        desc = 'Restore session',
      },
      {
        '<leader>ql',
        util.thunk(require('persistence').load, { last = true }),
        desc = 'Restore last session',
      },
      {
        '<leader>qd',
        require('persistence').stop,
        desc = 'Do not save current session',
      },
      {
        '<leader>qp',
        require('persistence').select,
        desc = 'Select session to restore',
      },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },

  {
    'folke/trouble.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },

      -- TODO Figure out whether any of these are worth keeping.
      -- { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
      -- { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      -- { '<leader>xL', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
      -- { '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },
      -- {
      --   '[q',
      --   function()
      --     if require('trouble').is_open() then
      --       require('trouble').previous { skip_groups = true, jump = true }
      --     else
      --       local ok, err = pcall(vim.cmd.cprev)
      --       if not ok then
      --         vim.notify(err, vim.log.levels.ERROR)
      --       end
      --     end
      --   end,
      --   desc = 'Previous Trouble/Quickfix Item',
      -- },
      -- {
      --   ']q',
      --   function()
      --     if require('trouble').is_open() then
      --       require('trouble').next { skip_groups = true, jump = true }
      --     else
      --       local ok, err = pcall(vim.cmd.cnext)
      --       if not ok then
      --         vim.notify(err, vim.log.levels.ERROR)
      --       end
      --     end
      --   end,
      --   desc = 'Next Trouble/Quickfix Item',
      -- },
    },
  },

  {
    'mbbill/undotree',
    keys = {
      { '<leader>cu', '<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>', desc = 'Toggle Undotree' },
    },
  },

  {
    'RRethy/vim-illuminate',
    event = 'BufReadPre',
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
      disable_keymaps = false,
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
    keys = {
      {
        ']]',
        function()
          require('illuminate').goto_next_reference(false)
        end,
        desc = 'Go to next reference',
      },
      {
        '[[',
        function()
          require('illuminate').goto_prev_reference(false)
        end,
        desc = 'Go to previous reference',
      },
      {
        '[]',
        function()
          require('illuminate').textobj_select()
        end,
        desc = 'Select word for use as text-object',
      },
    },
  },

  {
    'andymass/vim-matchup',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    event = 'BufReadPre',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      require('nvim-treesitter.configs').setup {
        matchup = {
          enable = true,
        },
      }
    end,
  },

  {
    'lukas-reineke/virt-column.nvim',
    opts = {},
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'folke/which-key.nvim',
      opts = {
        { '<leader>h', group = '+git', mode = { 'n', 'v' } },
      },
    },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        changedelete = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        untracked = { text = '+' },
      },
      -- signs = {
      --   add = { text = '▎' },
      --   change = { text = '▎' },
      --   changedelete = { text = '▎' },
      --   delete = { text = '' },
      --   topdelete = { text = '' },
      --   untracked = { text = '▎' },
      -- },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function lmap(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        lmap('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk 'next'
          end
        end, 'Go to next hunk')

        lmap('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk 'prev'
          end
        end, 'Go to previous hunk')

        -- Actions
        lmap('n', '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
        lmap('n', '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')

        lmap('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage selected lines')

        lmap('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset selected lines')

        lmap('n', '<leader>hS', gitsigns.stage_buffer, 'Stage buffer')
        lmap('n', '<leader>hR', gitsigns.reset_buffer, 'Reset buffer')
        lmap('n', '<leader>hp', gitsigns.preview_hunk, 'Preview hunk')
        lmap('n', '<leader>hi', gitsigns.preview_hunk_inline, 'Preview hunk inline')

        lmap('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end, 'Blame current line')

        lmap('n', '<leader>hd', gitsigns.diffthis, 'Vimdiff file')

        lmap('n', '<leader>hD', function()
          ---@diagnostic disable-next-line: param-type-mismatch
          gitsigns.diffthis '~'
        end, 'Vimdiff file against previous commit')

        lmap('n', '<leader>hQ', function()
          ---@diagnostic disable-next-line: param-type-mismatch
          gitsigns.setqflist 'all'
        end, 'Open QuickFix list with all hunks in all files')
        lmap('n', '<leader>hq', gitsigns.setqflist, 'Open QuickFix list with all hunks in current buffer')

        -- Toggles
        lmap('n', '<leader>hlb', gitsigns.toggle_current_line_blame, 'Toggle current line blame virtual text')
        lmap('n', '<leader>hiw', gitsigns.toggle_word_diff, 'Highlight word diffs inline')

        -- Text object
        lmap({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select hunk under cursor')
      end,
    },
  },

  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config { virtual_text = false }
    end,
  },

  {
    'nvim-tree/nvim-web-devicons',
    opts = {},
  },

  {
    'windwp/nvim-autopairs',
    dependencies = {
      {
        -- https://github.com/Saghen/blink.cmp/discussions/157
        'saghen/blink.cmp',
        opts = { completion = { accept = { auto_brackets = { enabled = true } } } },
      },
    },
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'vim' },
    },
  },
  {
    'shortcuts/no-neck-pain.nvim',
    dependencies = {
      'folke/which-key.nvim',
      opts = {
        { '<leader>un', group = '+NoNeckPain', mode = 'n' },
      },
    },
    enabled = nixCats 'full',
    version = '*',
    keys = {
      {
        '<leader>unn',
        '<cmd>NoNeckPain<cr>',
        desc = 'Toggle NoNeckPain',
      },
      {
        '<leader>unk',
        '<cmd>NoNeckPainWidthUp<cr>',
        desc = 'Increase NoNeckPain width',
      },
      {
        '<leader>unj',
        '<cmd>NoNeckPainWidthDown<cr>',
        desc = 'Decrease NoNeckPain width',
      },
      {
        '<leader>uns',
        '<cmd>NoNeckPainScratchPad<cr>',
        desc = 'Use NoNeckPain scratch pad',
      },
    },
  },

  {
    'julienvincent/hunk.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'neo-tree/nvim-web-devicons',
    },
    cmd = { 'DiffEditor' },
    opts = {},
  },

  {
    'fatih/vim-go',
    ft = { 'go', 'html', 'gotmpl', 'gohtmltmpl' },
    config = function()
      vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufWinEnter', 'BufWritePre' }, {
        group = vim.api.nvim_create_augroup('gotmpl_syntax', { clear = true }),
        pattern = '*.gohtml,*.gotmpl,*.html',
        callback = function(event)
          if vim.fn.search('{{.\\+}}', 'nw') ~= 0 then
            vim.api.nvim_set_option_value('filetype', 'gohtmltmpl', { buf = event.buf })
          end
        end,
      })
    end,
  },
}
