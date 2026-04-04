{ inputs, util, ... }:
util.mkProgram {
  name = "vim";
  hm = {
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "vim";
        value = inputs.wlib.lib.wrapperModules.vim;
      })
    ];
    wrappers.vim = {
      enable = true;
      vimrc = /* vim */ ''
        scriptencoding utf-8
        set encoding=utf-8

        " A combination of spaces and tabs are used to simulate tab stops at a width
        " other than the (hard)tabstop
        set softtabstop=0
        set tagstop=4
        set shftwidth=4
        set expandtab

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
