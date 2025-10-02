-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set
local util = require 'util'

-- Remove default keybindings for LSP
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gO')
vim.keymap.del('i', '<C-S>')

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to Left Window' })
map('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to Lower Window' })
map('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to Upper Window' })
map('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to Right Window' })
map('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
map('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

-- Windows
map('n', '<leader>ww', '<C-W>p', {
  desc = 'Other Window',
  remap = true,
})
map('n', '<leader>wd', '<C-W>c', {
  desc = 'Delete Window',
  remap = true,
})
map('n', '<leader>w-', '<C-W>s', {
  desc = 'Split Window Below',
  remap = true,
})
map('n', '<leader>w|', '<C-W>v', {
  desc = 'Split Window Right',
  remap = true,
})
map('n', '<leader>-', '<C-W>s', {
  desc = 'Split Window Below',
  remap = true,
})
map('n', '<leader>|', '<C-W>v', {
  desc = 'Split Window Right',
  remap = true,
})

-- Tabs
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Make j and k move through wrapped lines
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Buffers
map('n', '<S-h>', function()
  util.close_floating_windows()
  vim.cmd.bprevious()
end, { desc = 'Prev buffer' })
map('n', '<S-l>', function()
  util.close_floating_windows()
  vim.cmd.bnext()
end, { desc = 'Next buffer' })
map('n', '[b', function()
  util.close_floating_windows()
  vim.cmd.bprevious()
end, { desc = 'Prev buffer' })
map('n', ']b', function()
  util.close_floating_windows()
  vim.cmd.bnext()
end, { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })
map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua (from LazyVim?)
map('n', '<leader>ur', '<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>', {
  desc = 'Redraw / clear hlsearch / diff update',
})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", {
  expr = true,
  desc = 'Next Search Result',
})
map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", {
  expr = true,
  desc = 'Next Search Result',
})
map('n', 'N', "'nN'[v:searchforward].'zv'", {
  expr = true,
  desc = 'Prev Search Result',
})
map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", {
  expr = true,
  desc = 'Prev Search Result',
})

-- Add undo breakpoints
map('i', ',', ',<c-g>u', {})
map('i', '.', '.<c-g>u', {})
map('i', ';', ';<c-g>u', {})

-- keywordprg
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- Keep indented text selected with when indenting in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- New file
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New file' })

-- Troubleshooting
map('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location list' })
map('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix list' })
map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

local diagnostic_goto = function(next, severity)
  return function()
    local count = -1
    if next then
      count = 1
    end
    local sev = nil
    if type(severity) == 'string' then
      sev = vim.diagnostic.severity[severity]
    end
    return function()
      vim.diagnostic.jump { severity = sev, count = count, float = true }
    end
  end
end

map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', ']d', diagnostic_goto(true, nil), { desc = 'Next diagnostic' })
map('n', '[d', diagnostic_goto(false, nil), { desc = 'Prev diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev warning' })

map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect pos' })

map('n', 'g/', '*')
map('n', '[/', '[<C-i>')
map('n', '<C-w>/', function()
  local word = vim.fn.expand '<cword>'
  if word ~= '' then
    vim.cmd('split | silent! ijump /' .. word .. '/')
  end
end)
map('n', '<leader>/', require('snacks').picker.grep)
map('n', '<leader>g/', require('snacks').picker.grep_word)

map('x', '/', '<esc>/\\%V') -- `:h /\%V`
