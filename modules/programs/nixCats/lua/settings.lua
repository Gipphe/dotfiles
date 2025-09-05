-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
-- NOTE: nixCats: we asked nix if we have it instead of setting it here.
-- because nix is more likely to know if we have a nerd font or not.
vim.g.have_nerd_font = nixCats 'have_nerd_font'

vim.g.markdown_recommended_style = 0

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = not require('nixCatsUtils').enableForCategory 'droid'
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Save undo history
vim.opt.undofile = true
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undolevels = 10000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = require('nixCatsUtils').enableForCategory 'droid' and 'no' or 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show all hidden stuff by default. Mostly helpful for markdown, in my experience.
vim.opt.conceallevel = 0

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
-- Minimal number of screen columns to keep to the left and right of the cursor.
vim.opt.sidescrolloff = 8

vim.opt.shortmess:append { F = true, W = true, I = true, c = true, C = true }

-- Confirm to save changes before leaving modified buffer
vim.opt.confirm = true

-- Enable break indent
vim.opt.breakindent = true
-- Word-wrap
vim.opt.wrap = not require('nixCatsUtils').enableForCategory 'droid'
vim.opt.linebreak = true

vim.opt.title = true
vim.opt.titlestring = '%t %h%m%r%w (%{v:progname})'

-- Expand tabs to spaces
vim.opt.expandtab = true

-- Size of a tab
vim.opt.tabstop = 2
-- Round indent
vim.opt.shiftround = true
-- Indent size
vim.opt.shiftwidth = 2

-- True color support
vim.opt.termguicolors = true

-- Allow cursor to move where there is no text in visual block mode
vim.opt.virtualedit = 'block'

vim.opt.wildmode = 'longest:full,full'

vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

-- Start with all folds open
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'indent'

vim.opt.colorcolumn = '80'

vim.opt.formatoptions = 'jcroqlnt'
vim.opt.grepformat = '%f:%l:%c:%m'
-- Use ripgrep for searching
vim.opt.grepprg = 'rg --vimgrep'
-- Preview incremental substitute
vim.opt.inccommand = 'nosplit'
-- Global statusline
vim.opt.laststatus = 3

-- Popup blend
vim.opt.pumblend = 10
-- Maximum number of entries in a popup
vim.opt.pumheight = 10

vim.opt.swapfile = false
vim.opt.backup = false

-- For persistence.nvim
vim.opt.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  -- 'winsizes',
  'help',
  'globals',
  'skiprtp',
  'folds',
}
