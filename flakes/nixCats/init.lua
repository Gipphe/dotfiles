--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- NOTE: nixCats: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup {
  non_nix_value = true,
}

require 'settings'
require 'filetypes'
require 'keymaps'
require 'autocommands'

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end
local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

local icons = {
  misc = {
    dots = '󰇘',
  },
  dap = {
    Stopped = {
      '󰁕 ',
      'DiagnosticWarn',
      'DapStoppedLine',
    },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = {
      ' ',
      'DiagnosticError',
    },
    LogPoint = '.>',
  },
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  kinds = {
    Array = ' ',
    Boolean = '󰨙 ',
    Class = ' ',
    Codeium = '󰘦 ',
    Color = ' ',
    Control = ' ',
    Collapsed = ' ',
    Constant = '󰏿 ',
    Constructor = ' ',
    Copilot = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Key = ' ',
    Keyword = ' ',
    Method = '󰊕 ',
    Module = ' ',
    Namespace = '󰦮 ',
    Null = ' ',
    Number = '󰎠 ',
    Object = ' ',
    Operator = ' ',
    Package = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = ' ',
    String = ' ',
    Struct = '󰆼 ',
    TabNine = '󰏚 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
}

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
-- NOTE: nixCats: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {

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
    'ap/vim-css-color',
    event = 'BufReadPost',
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
        lmap('n', '<leader>td', gitsigns.toggle_deleted)
        lmap('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        lmap({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
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
      }
    end,
  },

  {
    -- TODO Fix python requirement for this.
    'gelguy/wilder.nvim',
    enabled = false,
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

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
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
  },

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

  -- { -- you can easily change to a different colorscheme.
  --   -- change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- if you want to see what colorschemes are already installed, you can use `:telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- make sure to load this before all the other start plugins.
  --   init = function()
  --     -- load the colorscheme here.
  --     -- like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'
  --
  --     -- you can configure highlights by doing something like:
  --     vim.cmd.hi 'comment gui=none'
  --   end,
  -- },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.setupopts
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
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      handle_leading_whitespace = true,
    },
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

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
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
        navic = {
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
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
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
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      'folke/which-key.nvim',
    },
  },

  {
    'rcarriga/nvim-notify',
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
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      bigfile = {},
      indent = {},
      picker = {},
      statuscolumn = {},
    },
    keys = {
      -- Commonly used pickers
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
        desc = 'Buffers',
      },
      {
        '<leader>/',
        function()
          require('snacks').picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>:',
        function()
          require('snacks').picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>n',
        function()
          require('snacks').picker.notifications()
        end,
        desc = 'Notification History',
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
        desc = 'Find Config File',
      },
      {
        '<leader>ff',
        function()
          require('snacks').picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fg',
        function()
          require('snacks').picker.git_files()
        end,
        desc = 'Find Git Files',
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
        desc = 'Git Branches',
      },
      {
        '<leader>gl',
        function()
          require('snacks').picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gL',
        function()
          require('snacks').picker.git_log_line()
        end,
        desc = 'Git Log Line',
      },
      {
        '<leader>gs',
        function()
          require('snacks').picker.git_status()
        end,
        desc = 'Git Status',
      },
      {
        '<leader>gS',
        function()
          require('snacks').picker.git_stash()
        end,
        desc = 'Git Stash',
      },
      {
        '<leader>gd',
        function()
          require('snacks').picker.git_diff()
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<leader>gf',
        function()
          require('snacks').picker.git_log_file()
        end,
        desc = 'Git Log File',
      },
      -- Grep
      {
        '<leader>sb',
        function()
          require('snacks').picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sB',
        function()
          require('snacks').picker.grep_buffers()
        end,
        desc = 'Grep Open Buffers',
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
        desc = 'Search History',
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
        desc = 'Buffer Lines',
      },
      {
        '<leader>sc',
        function()
          require('snacks').picker.command_history()
        end,
        desc = 'Command History',
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
        desc = 'Buffer Diagnostics',
      },
      {
        '<leader>sh',
        function()
          require('snacks').picker.help()
        end,
        desc = 'Help Pages',
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
        desc = 'Location List',
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
        desc = 'Man Pages',
      },
      {
        '<leader>sp',
        function()
          require('snacks').picker.lazy()
        end,
        desc = 'Search for Plugin Spec',
      },
      {
        '<leader>sq',
        function()
          require('snacks').picker.qflist()
        end,
        desc = 'Quickfix List',
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
        desc = 'Undo History',
      },
      {
        '<leader>uC',
        function()
          require('snacks').picker.colorschemes()
        end,
        desc = 'Colorschemes',
      },
    },
  },

  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'echasnovski/mini.nvim', version = '*' },
    },
    opts = {
      options = {
        close_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        right_mouse_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
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
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
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

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
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
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
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
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- NOTE: nixCats: return true only if category is enabled, else false
    enabled = require('nixCatsUtils').enableForCategory 'not-snacks',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
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
  { import = 'plugins' },
}, lazyOptions)

-- TODO This file is huge now (2985 lines at time of writing). Consider
-- splitting it up into sensible modules. Do _NOT_ split it into separate
-- modules for each plugin, but rather group the plugins based on categories.

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
