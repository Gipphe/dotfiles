local util = require 'util'

return {
  {
    'windwp/nvim-ts-autotag',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {},
    lazy = false,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
    },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      mode = 'cursor',
      max_lines = 3,
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    build = require('nixCatsUtils').lazyAdd ':TSUpdate',
    opts = {
      -- NOTE: nixCats: use lazyAdd to only set these 2 options if nix wasnt involved.
      -- because nix already ensured they were installed.
      ensure_installed = require('nixCatsUtils').lazyAdd { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      auto_install = require('nixCatsUtils').lazyAdd(true, false),

      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            [']a'] = '@parameter.inner',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
            [']A'] = '@parameter.inner',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[a'] = '@parameter.inner',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
            ['[A'] = '@parameter.inner',
          },
        },
      },
      refactor = {
        highlight_current_scope = {
          -- Basically highlight huge swaths of code all the time.
          enable = false,
        },
        highlight_definitions = {
          enable = true,
          clear_on_cursor_move = false,
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = 'gd',
            list_definitions = 'gD',
            goto_next_usage = '<a-*>',
            goto_previous_usage = '<a-#>',
          },
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = '<leader>cr',
          },
        },
      },
    },
    keys = {
      { '<leader>ut', '<cmd>TSContextToggle<cr>', desc = 'Toggle Treesitter context' },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = not util.is_windows()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      local hl_group = vim.api.nvim_create_augroup('highlight_nbsp', { clear = true })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = hl_group,
        command = 'highlight BreakSpaceChar ctermbg=red guibg=#f92672',
      })
      vim.api.nvim_create_autocmd('BufWinEnter', {
        group = hl_group,
        -- This space character is a unicode NBSP character. You can get one by
        -- pressing AltGr+Space on Linux. Code usually doesn't like it though.
        command = "call matchadd('BreakSpaceChar', ' ')",
      })
    end,
  },
}
