set nocompatible
set hidden
set number

set clipboard=unnamed

set history=500

filetype plugin on
filetype indent on

set autoread
set hlsearch

set noerrorbells
set novisualbell

set foldcolumn=1
syntax enable

set encoding=utf8
set smarttab

set ai
set si
set wrap

set nobackup
set noswapfile

set background=dark

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

set laststatus=2
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

set expandtab
set shiftwidth=2
set softtabstop=2
set showtabline=0

set number
set relativenumber

autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

:let mapleader = "-"

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-css-color'
Plug 'christoomey/vim-sort-motion'
Plug 'dyng/ctrlsf.vim'
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-signify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-smooth-scroll'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/auto-pairs-gentle'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

Plug 'joshdick/onedark.vim'

call plug#end()

colorscheme onedark

let g:AutoPairsUseInsertedCount = 1
let g:ctrlsf_ignore_dir = ['node_modules']

let b:ale_fixers = {
  \ 'typescript': ['eslint'],
  \ 'javascript': ['eslint']
\ }

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 10, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 10, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>

nmap <leader>fp <Plug>CtrlSFPrompt
nmap <leader>fs <Plug>CtrlSFCwordPath
nmap <leader>ff <Plug>CtrlSFPwordPath
nnoremap <leader>fz :FZF<CR>

nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> <leader>fr :ALEFindReferences<CR>

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! FormatXML call DoPrettyXML()

function! DoPrettyJSON()
  :%!python -m json.tool
endfunction
command! FormatJSON call DoPrettyJSON()

nnoremap <silent> gpj :FormatJSON<CR>
nnoremap <silent> gpx :FormatXML<CR>
