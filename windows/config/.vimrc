scriptencoding utf-8
set encoding=utf-8

syntax on
filetype on

" Disable backup files when saving a file with vim
set nobackup

" Size of a hard tabstop
set tabstop=4
" Size of an 'indent'
set shiftwidth=4

" A combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=0

"always use tabs instead of spaces
set noexpandtab

set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→

if exists('+colorcolumn')
	set colorcolumn=100
else
	au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
endif
