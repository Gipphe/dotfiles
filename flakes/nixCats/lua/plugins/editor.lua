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
    'magal1337/dataform.nvim',
    enable = require('nixCatsUtils').enableForCategory 'dataform',
    dependencies = {
      'rcarriga/nvim-notify',
      'nvim-telescope/telescope.nvim',
    },
    ft = {
      'dataform',
      'sqlx',
      'js',
      'ts',
    },
    keys = {
      { '<leader>cpa', '<cmd>DataformRunAction<cr>', desc = 'Dataform run currently open action' },
      { '<leader>cpd', '<cmd>DataformGoToRef<cr>', desc = 'Go to Dataform ref' },
      { '<leader>cpb', '<cmd>DataformCompileFull<cr>', desc = 'Compile current dataform file and view result' },
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
    version = false,
    opts = {
      name = {
        'venv',
        '.venv',
        'env',
        '.env',
      },
    },
    keys = {
      { '<leader>cv', '<cmd>VenvSelect<cr>', desc = 'Select VirtualEnv' },
      { '<leader>cV', '<cmd>VenvSelectCached<cr>', desc = 'Select cached VirtualEnv' },
    },
  },

  {
    'aca/marp.nvim',
    version = false,
    keys = {
      {
        '<leader>mpo',
        require('marp.nvim').ServerStart,
        desc = 'Start Marp server',
      },
      {
        '<leader>mpc',
        require('marp.nvim').ServerStop,
        desc = 'Stop Marp server',
      },
    },
    dependencies = {
      { 'folke/which-key.nvim' },
    },
    config = function(_, opts)
      require('marp').setup(opts or {})
      require('which-key').add {
        { '<leader>m', group = 'Marp' },
      }
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
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    lazy = false,
  },

  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore last session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = 'Do not save current session',
      },
      {
        '<leader>qp',
        function()
          require('persistence').select()
        end,
        desc = 'Select session to restore',
      },
    },
  },

  { -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
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
    dependencies = 'nvim-treesitter/nvim-treesitter',
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
    opts = {
      -- signs = {
      --   add = { text = '+' },
      --   change = { text = '~' },
      --   delete = { text = '_' },
      --   topdelete = { text = '‾' },
      --   changedelete = { text = '~' },
      -- },
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
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
            gitsigns.nav_hunk 'next'
          end
        end)

        lmap('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end)

        -- Actions
        lmap('n', '<leader>hs', gitsigns.stage_hunk)
        lmap('n', '<leader>hr', gitsigns.reset_hunk)

        lmap('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end)

        lmap('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end)

        lmap('n', '<leader>hS', gitsigns.stage_buffer)
        lmap('n', '<leader>hR', gitsigns.reset_buffer)
        lmap('n', '<leader>hp', gitsigns.preview_hunk)
        lmap('n', '<leader>hi', gitsigns.preview_hunk_inline)

        lmap('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end)

        lmap('n', '<leader>hd', gitsigns.diffthis)

        lmap('n', '<leader>hD', function()
          gitsigns.diffthis '~'
        end)

        lmap('n', '<leader>hQ', function()
          gitsigns.setqflist 'all'
        end)
        lmap('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        lmap('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        -- lmap('n', '<leader>td', gitsigns.toggle_deleted)
        lmap('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        lmap({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },
}
