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
    },
    config = function(_, spec) -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add(spec)
    end,
  },

  {
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPost',
    opts = {},
    dependencies = {
      'saghen/blink.cmp',
      opts = {
        completion = {
          menu = {
            draw = {
              components = {
                kind_icon = {
                  text = function(ctx)
                    local icon = ctx.kind_icon
                    if ctx.item.source_name == 'LSP' then
                      local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                      if color_item and color_item.abbr ~= '' then
                        icon = color_item.abbr
                      end
                    end
                    return icon .. ctx.icon_gap
                  end,
                  highlight = function(ctx)
                    local highlight = 'BlinkCmpKind' .. ctx.kind
                    if ctx.item.source_name == 'LSP' then
                      local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                      if color_item and color_item.abbr_hl_group then
                        highlight = color_item.abbr_hl_group
                      end
                    end
                    return highlight
                  end,
                },
              },
            },
          },
        },
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    enabled = nixCats 'full',
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
        function()
          require('snacks').picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>sT',
        function()
          require('snacks').picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
  },
}
