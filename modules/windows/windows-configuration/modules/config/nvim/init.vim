scriptencoding utf-8
set encoding=utf-8

syntax on
filetype on

set number
set relativenumber
set clipboard=unnamedplus
set foldmethod=indent

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
