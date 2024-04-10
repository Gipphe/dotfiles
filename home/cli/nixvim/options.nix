{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.gipphe.nixvim;
  icons = import ./icons.nix;
  inherit (config.nixvim) helpers;
in
{
  programs.nixvim = {
    withNodeJs = true;
    editorconfig.enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = "\\\\";
      autoformat = true;
      root_spec = [
        "lsp"
        [
          ".git"
          "lua"
        ]
        "cwd"
      ];
      markdown_recommended_style = 0;
    };
    extraConfigLuaPre = builtins.readFile ./configPre.lua;
    extraConfigLua = builtins.readFile ./config.lua;
    extraConfigLuaPost = builtins.readFile ./configPost.lua;
    opts = {
      autowrite = true;

      # Sync with system clipboard
      clipboard = "unnamedplus";

      # Confirm to save changes before leaving modified buffer
      confirm = true;

      # Highlight current line of cursor
      cursorline = true;

      # Use spaces instead of tabs
      expandtab = true;

      # tcqj
      formatoptions = "jcroqlnt";

      grepformat = "%f:%l:%c:%m";
      # Usr ripgrep for searching
      grepprg = "rg --vimgrep";

      ignorecase = true;
      # Preview incremental substitute
      inccommand = "nosplit";

      # Global statusline
      laststatus = 3;

      mouse = "a";

      # Show line numbers
      number = true;
      # Use relative line numbers
      relativenumber = true;

      # Popup blend
      pumblend = 10;

      # # Maximum number of entries in a popup
      pumheight = 10;

      # Lines of context
      scrolloff = 8;

      # Round indent
      shiftround = true;

      # Indent size
      shiftwidth = 2;

      # shortmess = "CnfoTOxcIWlitF";

      # Hide mode since we have a statusline
      showmode = false;

      # Columns of context
      sidescrolloff = 8;

      signcolumn = "yes";

      # Don't ignore case with capitals
      smartcase = true;

      # Insert indents automatically
      smartindent = true;

      spelllang = [ "en" ];

      timeoutlen = 300;

      # Put new windows below current
      splitbelow = true;

      splitkeep = "screen";

      # Put new windows to the right
      splitright = true;

      tabstop = 2;

      # True color support
      termguicolors = true;

      # Allow cursor to move where there is no text in visual block mode
      virtualedit = "block";

      # Command line completion
      wildmode = "longest:full,full";

      winminwidth = 5;

      fillchars = {
        foldopen = "";
        foldclose = "";
        fold = " ";
        foldsep = " ";
        diff = "╱";
        eob = " ";
      };
      # smoothscroll = true;

      foldlevel = 99;

      foldtext = "v:lua.utils.foldtext()";
      # }
      # // (
      #   if lib.strings.hasPrefix "10" config.programs.nixvim.package.version && false then
      #     {
      #       foldmethod = "expr";
      #       foldexpr = "v:lua.utils.foldexpr()";
      #       foldtext = "";
      #       fillchars = "fold: ";
      #     }
      #   else
      #     { foldmethod = lib.mkDefault "indent"; }
      # )
      # // {
      formatexpr = "v:lua.require'conform'.formatexpr()";

      # Set bash as default shell for commands
      shell = "${pkgs.bash}/bin/bash";

      updatetime = 50;
      colorcolumn = "80";
      wrap = true;
      linebreak = true;
      title = true;
      titlestring = "%t %h%m%r%w (%{v:progname})";
      list = true;
      conceallevel = 0;
      listchars = {
        tab = ">-";
        trail = "~";
        extends = ">";
        precedes = "<";
      };
      completeopt = [
        "menuone"
        "preview"
        "noinsert"
        "noselect"
      ];

      # Optimal for undotree
      swapfile = false;
      backup = false;
      undodir = helpers.mkRaw ''os.getenv("HOME") .. "/.vim/undodir"'';
      undofile = true;
      undolevels = 10000;
    };
  };
}
