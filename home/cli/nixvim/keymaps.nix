{ ... }:
let
  inherit (import ./util.nix) k kv;
in
{
  programs.nixvim.keymaps =
    [
      # better up/down
      (k
        [
          "n"
          "x"
        ]
        "j"
        "v:count == 0 ? 'gj' : 'j'"
        {
          expr = true;
          silent = true;
        }
      )
      (k
        [
          "n"
          "x"
        ]
        "<Down>"
        "v:count == 0 ? 'gj' : 'j'"
        {
          expr = true;
          silent = true;
        }
      )
      (k
        [
          "n"
          "x"
        ]
        "k"
        "v:count == 0 ? 'gk' : 'k'"
        {
          expr = true;
          silent = true;
        }
      )
      (k
        [
          "n"
          "x"
        ]
        "<Up>"
        "v:count == 0 ? 'gk' : 'k'"
        {
          expr = true;
          silent = true;
        }
      )

      # Move to window using the <ctrl> hjkl keys
      (k "n" "<C-h>" "<C-w>h" { desc = "Go to left window"; })
      (k "n" "<C-j>" "<C-w>j" { desc = "Go to lower window"; })
      (k "n" "<C-k>" "<C-w>k" { desc = "Go to upper window"; })
      (k "n" "<C-l>" "<C-w>l" { desc = "Go to right window"; })

      # Resize window using <ctrl> arrow keys
      (k "n" "<C-Up>" "<cmd>resize +2<cr>" { desc = "Increase window height"; })
      (k "n" "<C-Down>" "<cmd>resize -2<cr>" { desc = "Decrease window height"; })
      (k "n" "<C-Left>" "<cmd>vertical resize -2<cr>" { desc = "Decrease window width"; })
      (k "n" "<C-Right>" "<cmd>vertical resize +2<cr>" { desc = "Increase window width"; })

      # Move lines
      (k "n" "<A-j>" "<cmd>m .+1<cr>==" { desc = "Move down"; })
      (k "n" "<A-k>" "<cmd>m .-2<cr>==" { desc = "Move up"; })
      (k "i" "<A-j>" "<esc><cmd>m .+1<cr>==gi" { desc = "Move down"; })
      (k "i" "<A-k>" "<esc><cmd>m .-2<cr>==gi" { desc = "Move up"; })
      (k "v" "<A-j>" ":m '>+1<cr>gv=gv" { desc = "Move down"; })
      (k "v" "<A-k>" ":m '<-2<cr>gv=gv" { desc = "Move up"; })

      # Buffers
      (k "n" "<S-h>" "<cmd>bprevious<cr>" { desc = "Prev buffer"; })
      (k "n" "<S-l>" "<cmd>bnext<cr>" { desc = "Next buffer"; })
      (k "n" "[b" "<cmd>bprevious<cr>" { desc = "Prev buffer"; })
      (k "n" "]b" "<cmd>bnext<cr>" { desc = "Next buffer"; })
      (k "n" "<leader>bb" "<cmd>e #<cr>" { desc = "Switch to other buffer"; })
      (k "n" "<leader>`" "<cmd>e #<cr>" { desc = "Switch to other buffer"; })

      # Clear search with <esc>
      (k [
        "i"
        "n"
      ] "<esc>" "<cmd>noh<cr><esc>" { desc = "Escape and clear hlsearch"; })

      # Clear search, diff update and redraw
      # taken from runtime/lua/_editor.lua
      (k "n" "<leader>ur" "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>" {
        desc = "Redraw / clear hlsearch / diff update";
      })

      # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      (k "n" "n" "'Nn'[v:searchforward].'zv'" {
        expr = true;
        desc = "Next Search Result";
      })
      (k "x" "n" "'Nn'[v:searchforward]" {
        expr = true;
        desc = "Next Search Result";
      })
      (k "o" "n" "'Nn'[v:searchforward]" {
        expr = true;
        desc = "Next Search Result";
      })
      (k "n" "N" "'nN'[v:searchforward].'zv'" {
        expr = true;
        desc = "Prev Search Result";
      })
      (k "x" "N" "'nN'[v:searchforward]" {
        expr = true;
        desc = "Prev Search Result";
      })
      (k "o" "N" "'nN'[v:searchforward]" {
        expr = true;
        desc = "Prev Search Result";
      })

      # Add undo break-points
      (k "i" "," ",<c-g>u" { })
      (k "i" "." ".<c-g>u" { })
      (k "i" ";" ";<c-g>u" { })

      # Save file
      (k [
        "i"
        "n"
        "x"
        "s"
      ] "<C-s>" "<cmd>w<cr><esc>" { desc = "Save file"; })

      # keywordprg
      (k "n" "<leader>K" "<cmd>norm! K<cr>" { desc = "Keywordprg"; })

      # better indenting
      (k "v" "<" "<gv" { })
      (k "v" ">" ">gv" { })

      # lazy
      (k "n" "<leader>l" "<cmd>Lazy<cr>" { desc = "Lazy"; })

      # new file
      (k "n" "<leader>fn" "<cmd>enew<cr>" { desc = "New File"; })

      (k "n" "<leader>xl" "<cmd>lopen<cr>" { desc = "Location List"; })
      (k "n" "<leader>xq" "<cmd>copen<cr>" { desc = "Quickfix List"; })

      (kv "n" "[q" "vim.cmd.cprev" { desc = "Previous Quickfix"; })
      (kv "n" "]q" "vim.cmd.cnext" { desc = "Next Quickfix"; })

      # formatting
      (kv [
        "n"
        "v"
      ] "<leader>cf" ''function() require('conform').format({ bufnr = vim.fn.bufnr() }) end'' { desc = "Format"; })
    ]
    ++ (
      let

        # diagnostic
        diagnostic_goto = next: severity: ''
          function()
            local go = ${if next then "vim.diagnostic.goto_next" else "vim.diagnostic.goto_prev"}
            severity = ${if builtins.isString severity then "vim.diagnostic.severity[${severity}]" else "nil"}
            return function()
              go({ severity = severity })
            end
          end
        '';
      in
      [
        (kv "n" "<leader>cd" "vim.diagnostic.open_float" { desc = "Line diagnostics"; })
        (kv "n" "]d" (diagnostic_goto true null) { desc = "Next Diagnostic"; })
        (kv "n" "[d" (diagnostic_goto false null) { desc = "Prev Diagnostic"; })
        (kv "n" "]e" (diagnostic_goto true "ERROR") { desc = "Next Error"; })
        (kv "n" "[e" (diagnostic_goto false "ERROR") { desc = "Prev Error"; })
        (kv "n" "]w" (diagnostic_goto true "WARN") { desc = "Next Warning"; })
        (kv "n" "[w" (diagnostic_goto false "WARN") { desc = "Prev Warning"; })
      ]
    )
    ++ [

      # toggle options
      # Requires LazyVim, which we don't have in Nixvim.
      # (k "n" "<leader>uf" "function() LazyVim.format.toggle() end" { desc = "Toggle Auto Format (Global)" ;})
      # (k "n" "<leader>uF" "function() LazyVim.format.toggle(true) end" { desc = "Toggle Auto Format (Buffer)" ;})
      # (k "n" "<leader>us" "function() LazyVim.toggle("spell") end" { desc = "Toggle Spelling" ;})
      # (k "n" "<leader>uw" "function() LazyVim.toggle("wrap") end" { desc = "Toggle Word Wrap" ;})
      # (k "n" "<leader>uL" "function() LazyVim.toggle("relativenumber") end" { desc = "Toggle Relative Line Numbers" ;})
      # (k "n" "<leader>ul" "function() LazyVim.toggle.number() end" { desc = "Toggle Line Numbers" ;})
      # (k "n" "<leader>ud" "function() LazyVim.toggle.diagnostics() end" { desc = "Toggle Diagnostics" ;})
      # ]++ let 
      # local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
      # (k "n", "<leader>uc", function() LazyVim.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
      # if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
      #   (k  "n", "<leader>uh", function() LazyVim.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
      # end
      # (k "n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })
      # (k "n", "<leader>ub", function() LazyVim.toggle("background", false, {"light", "dark"}) end, { desc = "Toggle Background" })

      # lazygit
      # Requires Lazyvim
      # (kv "n" "<leader>gg" "function() LazyVim.lazygit( { cwd = LazyVim.root.git() }) end" { desc = "Lazygit (Root Dir)" ;})
      # (kv "n" "<leader>gG" "function() LazyVim.lazygit() end" { desc = "Lazygit (cwd)" ;})

      # Requires Lazyvim
      # (kv "n" "<leader>gf" ''function()
      #   local git_path = vim.api.nvim_buf_get_name(0)
      #   LazyVim.lazygit({args = { "-f", vim.trim(git_path) }})
      # end'', { desc = "Lazygit Current File History" })

      # quit
      (k "n" "<leader>qq" "<cmd>qa<cr>" { desc = "Quit All"; })

      # highlights under cursor
      (kv "n" "<leader>ui" "vim.show_pos" { desc = "Inspect Pos"; })

      # LazyVim Changelog
      # (k "n", "<leader>L", function() LazyVim.news.changelog() end, { desc = "LazyVim Changelog" })

      # floating terminal
      # local lazyterm = function() LazyVim.terminal(nil, { cwd = LazyVim.root() }) end
      # (k "n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
      # (k "n", "<leader>fT", function() LazyVim.terminal() end, { desc = "Terminal (cwd)" })
      # (k "n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
      # (k "n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

      # Terminal Mappings
      (k "t" "<esc><esc>" "<c-\\><c-n>" { desc = "Enter Normal Mode"; })
      (k "t" "<C-h>" "<cmd>wincmd h<cr>" { desc = "Go to Left Window"; })
      (k "t" "<C-j>" "<cmd>wincmd j<cr>" { desc = "Go to Lower Window"; })
      (k "t" "<C-k>" "<cmd>wincmd k<cr>" { desc = "Go to Upper Window"; })
      (k "t" "<C-l>" "<cmd>wincmd l<cr>" { desc = "Go to Right Window"; })
      (k "t" "<C-/>" "<cmd>close<cr>" { desc = "Hide Terminal"; })
      (k "t" "<c-_>" "<cmd>close<cr>" { desc = "which_key_ignore"; })

      # windows
      (k "n" "<leader>ww" "<C-W>p" {
        desc = "Other Window";
        remap = true;
      })
      (k "n" "<leader>wd" "<C-W>c" {
        desc = "Delete Window";
        remap = true;
      })
      (k "n" "<leader>w-" "<C-W>s" {
        desc = "Split Window Below";
        remap = true;
      })
      (k "n" "<leader>w|" "<C-W>v" {
        desc = "Split Window Right";
        remap = true;
      })
      (k "n" "<leader>-" "<C-W>s" {
        desc = "Split Window Below";
        remap = true;
      })
      (k "n" "<leader>|" "<C-W>v" {
        desc = "Split Window Right";
        remap = true;
      })

      # tabs
      (k "n" "<leader><tab>l" "<cmd>tablast<cr>" { desc = "Last Tab"; })
      (k "n" "<leader><tab>f" "<cmd>tabfirst<cr>" { desc = "First Tab"; })
      (k "n" "<leader><tab><tab>" "<cmd>tabnew<cr>" { desc = "New Tab"; })
      (k "n" "<leader><tab>]" "<cmd>tabnext<cr>" { desc = "Next Tab"; })
      (k "n" "<leader><tab>d" "<cmd>tabclose<cr>" { desc = "Close Tab"; })
      (k "n" "<leader><tab>[" "<cmd>tabprevious<cr>" { desc = "Previous Tab"; })
    ];
}
