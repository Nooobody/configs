
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

language en
set guifont=Source\ Code\ Pro:h12

nnoremap <silent> <leader>ot :!start "C:\Program Files\Git\git-bash.exe"<cr>

let g:screen_size_restore_pos = 1
let g:screen_size_by_vim_instance = 1

autocmd Filetype vue setlocal cursorline!
autocmd Filetype vue setlocal relativenumber!

set sessionoptions+=resize,winpos

