return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  version = '*',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('mini.ai').setup { n_lines = 500 }

    require('mini.surround').setup {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
    }

    require('mini.pairs').setup {}
    vim.g.minipairs_disable = true

    require('mini.comment').setup {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    }

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup {
      use_icons = vim.g.have_nerd_font,
    }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v (%p%%)'
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'help',
        'alpha',
        'dashboard',
        'neo-tree',
        'Trouble',
        'trouble',
        'lazy',
        'mason',
        'notify',
        'toggleterm',
        'lazyterm',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
  keys = {
    {
      '<leader>up',
      function()
        vim.g.minipairs_disable = not vim.g.minipairs_disable
        if vim.g.minipairs_disable then
          print 'Disabled auto pairs'
        else
          print 'Enable auto pairs'
        end
      end,
      desc = 'Toggle auto pairs',
    },
    {
      '<leader>bd',
      function()
        local bd = require('mini.bufremove').delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
          if choice == 1 then -- Yes
            vim.cmd.write()
            bd(0)
          elseif choice == 2 then
            bd(0, true)
          end
        else
          bd(0)
        end
      end,
      desc = 'Delete buffer',
    },
    {
      '<leader>bD',
      function()
        require('mini.bufremove').delete(0, true)
      end,
      desc = 'Delete buffer (force)',
    },
  },
}
