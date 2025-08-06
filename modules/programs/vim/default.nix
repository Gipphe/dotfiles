{ util, ... }:
util.mkProgram {
  name = "vim";
  hm = {
    programs.vim = {
      enable = true;
      settings = {
        # Size of a hard tabstop
        tabstop = 4;
        # Size of an 'indent'
        shiftwidth = 4;
        # always use tabs instead of spaces
        expandtab = false;
      };
      extraConfig = ''
        scriptencoding utf-8
        set encoding=utf-8

        " A combination of spaces and tabs are used to simulate tab stops at a width
        " other than the (hard)tabstop
        set softtabstop=0

        set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→

        if exists('+colorcolumn')
          set colorcolumn=100
        else
          au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
        endif
      '';
    };
  };
}
