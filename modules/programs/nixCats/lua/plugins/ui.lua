local icons = require('util').icons

return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'echasnovski/mini.nvim',
    },
    ---@module 'bufferline'
    ---@type bufferline.UserConfig
    opts = {
      options = {
        close_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        right_mouse_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and icons.diagnostics.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.diagnostics.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
      },
    },
    event = 'VeryLazy',
    keys = {
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    },
  },

  {
    'catppuccin/nvim',
    name = require('nixCatsUtils').lazyAdd('catppuccin', 'catppuccin-nvim'),
    priority = 1000,
    ---@type CatppuccinOptions
    opts = {
      flavour = 'macchiato',
      show_end_of_buffer = true,
      integrations = {
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = {
          enabled = true,
        },
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        mini = {
          enabled = true,
        },
        native_lsp = {
          enabled = true,
        },
        noice = true,
        notify = true,
        telescope = {
          enabled = true,
        },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },

  {
    'folke/noice.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      'folke/which-key.nvim',
    },
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = ', after #%d+' },
              { find = ', before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
    },
    config = function(_, opts)
      require('noice').setup(opts)
      require('which-key').add {
        { '<leader>sn', group = '+noice' },
      }
    end,
    keys = {
      {
        '<S-Enter>',
        function()
          require('noice').redirect(vim.fn.getcmdline())
        end,
        mode = 'c',
        desc = 'Redirect cmdline',
      },
      {
        '<leader>snl',
        function()
          require('noice').cmd 'last'
        end,
        desc = 'Noice last message',
      },
      {
        '<leader>snh',
        function()
          require('noice').cmd 'history'
        end,
        desc = 'Noice history',
      },
      {
        '<leader>sna',
        function()
          require('noice').cmd 'all'
        end,
        desc = 'Noice all',
      },
      {
        '<leader>snd',
        function()
          require('noice').cms 'dismiss'
        end,
        desc = 'Dismiss all',
      },
      {
        '<c-f>',
        function()
          if not require('noice.lsp').scroll(4) then
            return '<c-f>'
          end
        end,
        mode = { 'i', 'n', 's' },
        expr = true,
        desc = 'Scroll forwards',
      },
      {
        '<c-b>',
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<c-b>'
          end
        end,
        mode = { 'i', 'n', 's' },
        expr = true,
        desc = 'Scroll backwards',
      },
    },
  },

  {
    'rcarriga/nvim-notify',
    enabled = require('nixCatsUtils').enableForCategory 'full',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    ---@module 'notify'
    ---@type notify.Config
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        -- TODO Is this one necessary?
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    lazy = false,
    keys = {
      {
        '<leader>un',
        function()
          require('notify').dismiss { silent = true, pending = true }
        end,
        desc = 'Dismiss all notifications',
      },
    },
  },

  {
    'gelguy/wilder.nvim',
    opts = {
      modes = {
        '/',
        '?',
        ':',
      },
    },
  },

  {
    'swaits/zellij-nav.nvim',
    lazy = true,
    event = 'VeryLazy',
    opts = {},
    keys = {
      { '<C-h>', '<cmd>ZellijNavigateLeftTab<cr>', desc = 'Navigate left' },
      { '<C-l>', '<cmd>ZellijNavigateRightTab<cr>', desc = 'Navigate right' },
      { '<C-j>', '<cmd>ZellijNavigateDown<cr>', desc = 'Navigate down' },
      { '<C-k>', '<cmd>ZellijNavigateUp<cr>', desc = 'Navigate up' },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    ---@type wk.Spec
    opts = {
      -- TODO Should these groups be separated so that I can easily reference them in actual keybinding definitions?
      { 'g', group = '+goto', mode = { 'n', 'v' } },
      { 'gs', group = '+surround', mode = { 'n', 'v' } },
      { 'z', group = '+fold', mode = { 'n', 'v' } },
      { ']', group = '+next', mode = { 'n', 'v' } },
      { '[', group = '+prev', mode = { 'n', 'v' } },
      { '<leader><tab>', group = '+tabs', mode = { 'n', 'v' } },

      { '<leader>b', group = '+buffer', mode = { 'n', 'v' } },
      { '<leader>c', group = '+code', mode = { 'n', 'v' } },
      { '<leader>f', group = '+file/find', mode = { 'n', 'v' } },
      { '<leader>g', group = '+git', mode = { 'n', 'v' } },
      { '<leader>gh', group = '+hunks', mode = { 'n', 'v' } },
      { '<leader>q', group = '+quit/session', mode = { 'n', 'v' } },
      { '<leader>s', group = '+search', mode = { 'n', 'v' } },
      { '<leader>u', group = '+ui', mode = { 'n', 'v' } },
      { '<leader>w', group = '+windows', mode = { 'n', 'v' } },
      { '<leader>x', group = '+diagnostics/quickfix', mode = { 'n', 'v' } },
      { '<leader>t', group = '+telescope', mode = { 'n', 'v' } },
      -- TODO Are any of these relevant now?
      -- { '<leader>c', group = 'Code' },
      -- { '<leader>c_', hidden = true },
      -- { '<leader>d', group = 'Document' },
      -- { '<leader>d_', hidden = true },
      -- { '<leader>r', group = 'Rename' },
      -- { '<leader>r_', hidden = true },
      -- { '<leader>s', group = 'Search' },
      -- { '<leader>s_', hidden = true },
      -- { '<leader>t', group = 'Toggle' },
      -- { '<leader>t_', hidden = true },
      -- { '<leader>w', group = 'Workspace' },
      -- { '<leader>w_', hidden = true },
      -- {
      --   mode = { 'v' },
      --   { '<leader>h', group = 'Git hunk' },
      --   { '<leader>h_', hidden = true },
      -- },
    },
    config = function(_, spec) -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add(spec)
    end,
  },

  {
    'ap/vim-css-color',
    event = 'BufReadPost',
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@type TodoOptions
    opts = {
      signs = false,
    },
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next todo comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous todo comment',
      },
      {
        '<leader>xt',
        '<cmd>TodoTrouble<cr>',
        desc = 'Todo (Trouble)',
      },
      {
        '<leader>xT',
        '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>',
        desc = 'Todo/Fix/Fixme (Trouble)',
      },
      {
        '<leader>st',
        '<cmd>TodoTelescope<cr>',
        desc = 'Todo',
      },
      {
        '<leader>sT',
        '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr',
        desc = 'Todo/Fix/Fixme',
      },
    },
  },
}
