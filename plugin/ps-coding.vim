set et sw=2 ts=2
let s:path = expand('<sfile>:h')

let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '-std=c++14'

" UltiSnips configuration
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=[s:path . "/../UltiSnips"]

" YCM
let g:ycm_extra_conf_globlist = [ "$HOME/src/*" ]

" make configuration
"let $CXXFLAGS='-static -DONLINE_JUDGE -lm -s -x c++ -Wl,--stack=268435456 -O2 -std=c++11 -D__USE_MINGW_ANSI_STDIO=0'
let $CXXFLAGS='-static -lm -s -x c++ -Wl,--stack=268435456 -O2 -std=c++11 -D__USE_MINGW_ANSI_STDIO=0'

function! MakeAndRun()
  let l:curr_win_nr = bufwinnr("%")
  let l:src_win_nr = bufwinnr("{cpp,cc}$")
  if l:src_win_nr == -1
    echom "No file to compile"
    return
  endif
  exe l:src_win_nr . "wincmd w"
  let l:src_name = bufname("%")
  up

  let l:exe_name = fnamemodify(l:src_name, ":r")
  echom "compiling " . l:src_name
  execute "silent make " . l:exe_name
  if len(getqflist()) == 1
    echom "executing " . l:exe_name
    let l:input_file = l:exe_name . ".in"
    if bufwinnr("^" . l:input_file . "$") < 0
        execute "bo sp " . l:input_file 
    endif
    let l:exe_buf = bufwinnr("!bash -c \"./" . l:exe_name)
    if l:exe_buf > 0
        exe l:exe_buf . "wincmd q"
    endif
    if filereadable(l:input_file)
        exec bufwinnr("^" . l:input_file. "$") . "wincmd w"
        execute "bel vert term bash -c \"./" . l:exe_name . " < " . l:input_file . "\""
    else
        execute "bel vert term ./" . l:exe_name
    endif
  else
    for i in getqflist()
      if i['valid']
        cwin
        winc p
        return
      endif
    endfor
  endif
  redraw!
endfunction
imap <F5> <esc> :call MakeAndRun() <cr>
nmap <F5> :call MakeAndRun() <cr>
nmap <F6> :%y+<cr>
