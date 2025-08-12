return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      -- NOTE: nixCats: use lazyAdd to only run build steps if nix wasnt involved.
      -- because nix already did this.
      build = require('nixCatsUtils').lazyAdd 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      -- NOTE: nixCats: use lazyAdd to only add this if nix wasnt involved.
      -- because nix built it already, so who cares if we have make in the path.
      cond = require('nixCatsUtils').lazyAdd(function()
        return vim.fn.executable 'make' == 1
      end),
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

    {
      -- TODO Reconsider whether I need this one
      'nvim-telescope/telescope-github.nvim',
      enabled = false,
      keys = {
        { '<leader>tgi', '<cmd>Telescope gh issues<cr>', desc = 'Find GitHub issues (gh)' },
        { '<leader>tgp', '<cmd>Telescope gh pull_requests', desc = 'Find GitHub pull requests (gh)' },
        { '<leader>tgg', '<cmd>Telescope gh gist<cr>', desc = 'Find GitHub gists (gh)' },
        { '<leader>tgw', '<cmd>Telescope gh run<cr>', desc = 'Find GitHub workflow runs (gh)' },
      },
    },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
      },
      -- pickers = {}
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'github')

    -- TODO Reconsider which of these I need.
    -- See `:help telescope.builtin`
    -- local builtin = require 'telescope.builtin'
    -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    --
    -- -- Slightly advanced example of overriding default behavior and theme
    -- vim.keymap.set('n', '<leader>/', function()
    --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --     winblend = 10,
    --     previewer = false,
    --   })
    -- end, { desc = '[/] Fuzzily search in current buffer' })
    --
    -- -- It's also possible to pass additional configuration options.
    -- --  See `:help telescope.builtin.live_grep()` for information about particular keys
    -- vim.keymap.set('n', '<leader>s/', function()
    --   builtin.live_grep {
    --     grep_open_files = true,
    --     prompt_title = 'Live Grep in Open Files',
    --   }
    -- end, { desc = '[S]earch [/] in Open Files' })
    --
    -- -- Shortcut for searching your Neovim configuration files
    -- vim.keymap.set('n', '<leader>sn', function()
    --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
    -- end, { desc = '[S]earch [N]eovim files' })
  end,
  keys = {
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Grep files' },
    { '<leader>,', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Switch buffer' },
    { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command history' },
    { '<leader><space>', '<cmd>Telescope find_files<cr>', desc = 'Find files (cwd)' },
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files (cwd)' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },

    -- TODO Find our whether I want to keep any of these.
    -- -- Git
    -- { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Commits' },
    -- { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'Status' },
    --
    -- { '<leader>s"', '<cmd>Telescope registers<cr>', desc = 'Registers' },
    -- { '<leader>sa', '<cmd>Telescope autocommands<cr>', desc = 'Auto commands' },
    -- { '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
    -- { '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command history' },
    -- { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
    -- { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document diagnostics' },
    -- { '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace diagnostics' },
    -- {
    --   '<leader>sg',
    --   function()
    --     require('telescope.builtin').live_grep { cwd = get_current_dir() }
    --   end,
    --   desc = 'Grep (current dir)',
    -- },
    -- { '<leader>sG', '<cmd>Telescope live_grep<cr>', desc = 'Grep (cwd)' },
    -- { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help pages' },
    -- { '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search highlight groups' },
    -- { '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key maps' },
    -- { '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man pages' },
    -- { '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to mark' },
    -- { '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
    -- { '<leader>sR', '<cmd>Telescope resume<cr>', desc = 'Resume' },
    -- {
    --   '<leader>sw',
    --   function()
    --     require('telescope.builtin').grep_string { word_match = '-w', cwd = get_durrent_dir() }
    --   end,
    --   desc = 'Word (current dir)',
    -- },
    -- {
    --   '<leader>sW',
    --   function()
    --     require('telescope.builtin').grep_string { word_match = '-w' }
    --   end,
    --   desc = 'Word (cwd)',
    -- },
    -- {
    --   '<leader>sw',
    --   function()
    --     require('telescope.builtin').grep_string { cwd = get_current_dir() }
    --   end,
    --   mode = 'v',
    --   desc = 'Selection (current dir)',
    -- },
    -- { '<leader>sW', '<cmd>Telescope grep_string<cr>', mode = 'v', desc = 'Selection (cwd)' },
    -- {
    --   '<leader>uC',
    --   function()
    --     require('telescope.builtin').colorscheme { enable_preview = true }
    --   end,
    --   desc = 'Colorscheme with Preview',
    -- },
  },
}
