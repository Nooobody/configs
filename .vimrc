set nocompatible
set hidden
set number

set clipboard=unnamed

set history=500

filetype plugin on
filetype indent on

set cursorline

set autoread
set hlsearch

set noerrorbells
set novisualbell

set backspace=indent,eol,start

set foldcolumn=1
syntax enable

set encoding=utf8
set smarttab

set ai
set si
set wrap

set nobackup
set noswapfile

" autocmd BufEnter * silent! lcd %:p:h

map <C-j> <C-d>
map <C-k> <C-u>

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

nnoremap <silent> <ESC> :noh<CR>

nnoremap <leader>ov :e ~/.vimrc<cr>

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-css-color'
Plug 'christoomey/vim-sort-motion'
Plug 'dbakker/vim-projectroot'
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-signify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'skywind3000/asyncrun.vim'
Plug 'terryma/vim-smooth-scroll'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/auto-pairs-gentle'
Plug 'gruvbox-community/gruvbox'
" Plug 'trusktr/seti.vim'

call plug#end()

let g:gruvbox_contrast_dark = 'hard'

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

let g:gruvbox_invert_selection='0'

colorscheme gruvbox
" colorscheme seti

let g:asyncrun_open = 8
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

noremap <leader>cc :call asyncrun#quickfix_toggle(8)<CR>

let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsMapCh = 0
let g:AutoPairsMapSpace = 0
let g:AutoPairsMoveCharacter = ''

let g:ctrlsf_ignore_dir = ['node_modules', 'android', 'ios', 'build']

let g:fzf_preview_window = 'right:60%'

nmap <silent> <leader>gs :G<CR>
nmap <silent> <C-s> :G<CR>

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 2, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 2, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 2, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 2, 4)<CR>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nmap <leader>fp <Plug>CtrlSFPrompt
nmap <leader>fc <Plug>CtrlSFCwordExec
nnoremap <leader>fz :GFiles --exclude-standard --others --cached<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fgz :FZF<CR>
nnoremap <leader>ft :CtrlSF TODO

nmap gd <Plug>(coc-definition)
nmap <leader>fr <Plug>(coc-references)

nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bp :bp<CR>
nnoremap <silent> <leader>bb :bp<CR>
nnoremap <silent> <leader>bl :ls<CR>
nnoremap <leader>bg :ls<CR>:buffer<Space>

nnoremap <silent> <leader>e :Explore<CR>
nnoremap <silent> <leader>vr :so $MYVIMRC<CR>

nmap <silent> <leader>s :source ~/session.vim<CR>
let g:coc_disable_startup_warning = 1

imap <silent> <C-e> <Plug>(emmet-expand-abbr)

function! <SID>AutoProjectRootCD()
  try
    if &ft != 'help'
      ProjectRootCD
    endif  
  catch
    " Silently ignore invalid buffers
  endtry
endfunction
autocmd BufEnter * call <SID>AutoProjectRootCD()

nmap <silent> <leader>fi "iyiwgg/import<CR>vip<ESC>oimport <ESC>"ipysiw{A from "./<ESC>"ip<C-o><C-o><C-o>

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

autocmd VimLeave * :mksession! ~/session.vim
