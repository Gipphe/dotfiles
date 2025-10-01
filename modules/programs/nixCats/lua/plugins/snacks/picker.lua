return {
  'folke/snacks.nvim',
  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
    },
    {
      'folke/which-key.nvim',
      opts = {
        { '<leader>g', group = '+pickers', mode = { 'n', 'v' } },
      },
    },
  },
  ---@type snacks.Config
  opts = {
    picker = {},
  },
  keys = {
    {
      '<leader><space>',
      function()
        require('snacks').picker.smart()
      end,
      desc = 'Smart find files',
    },
    {
      '<leader>,',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Find buffers',
    },
    {
      '<leader>:',
      function()
        require('snacks').picker.command_history()
      end,
      desc = 'Find commands',
    },
    {
      '<leader>/',
      function()
        require('snacks').picker.grep()
      end,
      desc = 'Grep files',
    },
    {
      '<leader>:',
      function()
        require('snacks').picker.command_history()
      end,
      desc = 'Find command history',
    },
    {
      '<leader>gn',
      function()
        require('snacks').picker.notifications()
      end,
      desc = 'Notification history',
    },

    -- Find
    {
      '<leader>fb',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>fc',
      function()
        ---@diagnostic disable-next-line: assign-type-mismatch
        require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Find config file',
    },
    {
      '<leader>ff',
      function()
        require('snacks').picker.files()
      end,
      desc = 'Find files',
    },
    {
      '<leader>fg',
      function()
        require('snacks').picker.git_grep()
      end,
      desc = 'Grep git files',
    },
    {
      '<leader>fp',
      function()
        require('snacks').picker.projects()
      end,
      desc = 'Projects',
    },
    {
      '<leader>fr',
      function()
        require('snacks').picker.recent()
      end,
      desc = 'Recent',
    },
    -- git
    {
      '<leader>gb',
      function()
        require('snacks').picker.git_branches()
      end,
      desc = 'Git branches',
    },
    {
      '<leader>gl',
      function()
        require('snacks').picker.git_log()
      end,
      desc = 'Git log',
    },
    {
      '<leader>gL',
      function()
        require('snacks').picker.git_log_line()
      end,
      desc = 'Git log line',
    },
    {
      '<leader>gs',
      function()
        require('snacks').picker.git_status()
      end,
      desc = 'Git status',
    },
    {
      '<leader>gS',
      function()
        require('snacks').picker.git_stash()
      end,
      desc = 'Git stash',
    },
    {
      '<leader>gd',
      function()
        require('snacks').picker.git_diff()
      end,
      desc = 'Git diff (hunks)',
    },
    {
      '<leader>gf',
      function()
        require('snacks').picker.git_log_file()
      end,
      desc = 'Git log file',
    },
    -- Grep
    {
      '<leader>sb',
      function()
        require('snacks').picker.lines()
      end,
      desc = 'Buffer lines',
    },
    {
      '<leader>sB',
      function()
        require('snacks').picker.grep_buffers()
      end,
      desc = 'Grep open buffers',
    },
    {
      '<leader>sg',
      function()
        require('snacks').picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>sw',
      function()
        require('snacks').picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    -- search
    {
      '<leader>s"',
      function()
        require('snacks').picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>s/',
      function()
        require('snacks').picker.search_history()
      end,
      desc = 'Search history',
    },
    {
      '<leader>sa',
      function()
        require('snacks').picker.autocmds()
      end,
      desc = 'Autocmds',
    },
    {
      '<leader>sb',
      function()
        require('snacks').picker.lines()
      end,
      desc = 'Buffer lines',
    },
    {
      '<leader>sc',
      function()
        require('snacks').picker.command_history()
      end,
      desc = 'Command history',
    },
    {
      '<leader>sC',
      function()
        require('snacks').picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>sd',
      function()
        require('snacks').picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sD',
      function()
        require('snacks').picker.diagnostics_buffer()
      end,
      desc = 'Buffer diagnostics',
    },
    {
      '<leader>sh',
      function()
        require('snacks').picker.help()
      end,
      desc = 'Help pages',
    },
    {
      '<leader>sH',
      function()
        require('snacks').picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<leader>si',
      function()
        require('snacks').picker.icons()
      end,
      desc = 'Icons',
    },
    {
      '<leader>sj',
      function()
        require('snacks').picker.jumps()
      end,
      desc = 'Jumps',
    },
    {
      '<leader>sk',
      function()
        require('snacks').picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>sl',
      function()
        require('snacks').picker.loclist()
      end,
      desc = 'Location list',
    },
    {
      '<leader>sm',
      function()
        require('snacks').picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sM',
      function()
        require('snacks').picker.man()
      end,
      desc = 'Man pages',
    },
    {
      '<leader>sp',
      function()
        require('snacks').picker.lazy()
      end,
      desc = 'Search for plugin spec',
    },
    {
      '<leader>sq',
      function()
        require('snacks').picker.qflist()
      end,
      desc = 'Quickfix list',
    },
    {
      '<leader>sR',
      function()
        require('snacks').picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>su',
      function()
        require('snacks').picker.undo()
      end,
      desc = 'Undo history',
    },
    {
      '<leader>uC',
      function()
        require('snacks').picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
  },
}
