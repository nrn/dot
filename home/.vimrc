set nocompatible

" Settings
set backupdir=~/.vim/backups
set binary
if exists('+colorcolumn')
  set colorcolumn=80
  highlight ColorColumn ctermbg=211
endif
set cm=blowfish
set directory=~/.vim/swaps
set diffopt+=vertical
set encoding=utf-8 nobomb
set esckeys
"set cursorline
set expandtab
set gdefault
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lcs=tab:▸\ ,trail:·,eol:⚔,nbsp:_ " Show “invisible” characters
set list
let mapleader=","
set mouse=a
set noeol
set noerrorbells
set nostartofline
set number
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess=atI
set showmode
set smartcase
set t_Co=256
set tabstop=2
set tags+=~/github/tags
set title
"set ttyfast
if exists("&undodir")
  set undodir=~/.vim/undo
  set undofile
  set undolevels=1000
  set undoreload=10000
endif
set wildmenu

" Functions
function Encrypted()
  setlocal noswapfile
  set viminfo=
  set foldmethod=indent
  set foldlevel=0
  set foldclose=all
  "set fdo=insert
  "set fdl=1
  set cms="hidden"
  set foldtext=MyFoldText()
endfunction

function MyFoldText()
  let line = v:foldend - v:foldstart
  return v:folddashes . line
endfunction

autocmd BufReadPre * if system("head -c 9 " . expand("<afile>")) == "VimCrypt~" | call Encrypted() | endif

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

" Remaps
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

" window
nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>

" buffer
nmap <leader>s<left>   :leftabove  vnew<CR>
nmap <leader>s<right>  :rightbelow vnew<CR>
nmap <leader>s<up>     :leftabove  new<CR>
nmap <leader>s<down>   :rightbelow new<CR>

" Arrow keys move visible line
nnoremap  <Down> gj
nnoremap  <Up> gk
vnoremap  <Down> gj
vnoremap  <Up> gk

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-k> mz:m-2<cr>`z
nmap <M-j> mz:m+<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

nnoremap oo :only<cr>:next<cr>:Gdiff<cr>
nnoremap OO :only<cr>:previous<cr>:Gdiff<cr>

nmap <f2> :w<cr>:!node %<cr>
nmap <f3> :w<cr>:!node debug %<cr>
nmap <f4> :w<cr>:!npm test<cr>
nmap <f5> :w<cr>:!npm start<cr>
nmap <f6> :w<cr>:!bundle exec rspec spec<cr>
nnoremap <F9> :UndotreeToggle<cr>
nnoremap <silent> <F10> :YRShow<CR>
nmap <f12> :w<cr>:!git commit -a && git put<cr>

" Syntax checking stuff
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_check_on_wq = 0

let g:ctrlp_map = '<c-f>'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v(node_modules|[\/]\.(git|hg|svn)$)'

let g:NERDCustomDelimiters = {
    \ 'javascript': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' }
    \ }

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'mbbill/undotree'

" To consider trying again later.
" Plugin 'marijnh/tern_for_vim'
" Plugin 'szw/vim-ctrlspace'

call vundle#end()
syntax on
filetype plugin indent on
" call tern#DefaultKeyMap('j')

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
