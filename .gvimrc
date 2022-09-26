
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

language en
set guifont=Source\ Code\ Pro:h12

let g:kek_font = 'Source\ Code\ Pro:h'
let g:kek_font_size = 12

function! SetFont()
  execute ':set guifont=' . g:kek_font . g:kek_font_size
endfunction

function! DoIncreaseFont()
  let g:kek_font_size = g:kek_font_size + 2
  call SetFont()
endfunction

function! DoDecreaseFont()
  let g:kek_font_size = g:kek_font_size - 2
  call SetFont()
endfunction

function! DoDefaultFont()
  let g:kek_font_size = 12
  call SetFont()
endfunction

command! IncreaseFont call DoIncreaseFont()
command! DecreaseFont call DoDecreaseFont()
command! DefaultFont call DoDefaultFont()
nnoremap <silent> <leader>ffa :IncreaseFont<CR>
nnoremap <silent> <leader>ffz :DecreaseFont<CR>
nnoremap <silent> <leader>ffd :DefaultFont<CR>

let $FZF_DEFAULT_COMMAND='ag -g "" --ignore node_modules'

nnoremap <silent> <leader>ot :!start "C:\Program Files\Git\git-bash.exe"<cr>
nnoremap <leader>fgp :FZF ~/Documents/Projects<CR>
nnoremap <leader>og :e ~/.gvimrc<cr>

autocmd Filetype vue setlocal cursorline!
autocmd Filetype vue setlocal relativenumber!

set sessionoptions+=resize,winpos

if has("gui_running")
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif has('win32')
      return $HOME.'\.vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && filereadable(f)
      let vim_instance = 'GVIM'
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running")
      let vim_instance = 'GVIM'
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  autocmd VimEnter * call ScreenRestore()
  autocmd VimLeavePre * call ScreenSave()
endif
