" Make vim more useful
set nocompatible
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
  set undodir=~/.vim/undo
endif

" Enable line numbers
set number
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set expandtab
set shiftwidth=2
set tabstop=2
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" Search
set hlsearch
set ignorecase
set smartcase
set incsearch

" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title

" Color 80th column
if exists('+colorcolumn')
  set colorcolumn=80
endif

" Term color
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256
endif

" Start scrolling three lines before the horizontal window border
set scrolloff=3

autocmd BufReadPre * if system("head -c 9 " . expand("<afile>")) == "VimCrypt~" | call Encrypted() | endif
function Encrypted()
  setlocal noswapfile
  set viminfo=
  set foldmethod=indent
  set foldlevel=0
  set foldclose=all
  set fdo=insert
  set fdl=1
  set cms="hidden"
  set foldtext=MyFoldText()
endfunction

function MyFoldText()
  let line = v:foldend - v:foldstart
  return v:folddashes . line 
endfunction

" Strip trailing whitespace (,ss)
function! StripWhitespace ()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace ()<CR>

" Settings toggles
nmap \l :setlocal number!<CR>
nmap \o :set paste!<CR>

nmap \q :nohlsearch<CR>

nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

nmap \s :set spell!<CR>

" Buffer Navigation
nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>

" Mash jk to escape
inoremap jk <esc>
inoremap kj <esc>

" Easy navigation in split screen
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Arrow keys move visible line
nnoremap  <Down> gj
nnoremap  <Up> gk
vnoremap  <Down> gj
vnoremap  <Up> gk

nmap <f2> :w<cr>:!node %<cr>
nmap <f3> :w<cr>:!coffee %<cr>
nmap <f6> :w<cr>:!bundle exec rspec spec<cr>
nmap <f4> :w<cr>:!npm test<cr>
nmap <f5> :w<cr>:!npm start<cr>
nmap <f12> :w<cr>:!git commit -a && git push<cr>

" Still playing w/ this. closure compiler.jar not included
let g:syntastic_javascript_checker = "closurecompiler"
let g:syntastic_javascript_closure_compiler_path = './.vim/compiler.jar'

" Pathogen
call pathogen#infect()
syntax on
filetype indent on
filetype plugin indent on

