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
  silent !echo "[compiling] %:r"
  silent make %:r
  redraw!
  if len(getqflist()) == 1
    silent !echo "[executing] %:r"
    !./%:r
  else
    for i in getqflist()
      if i['valid']
        cwin
        winc p
        return
      endif
    endfor
  endif
endfunction
nmap <F5> :call MakeAndRun() <cr>
nmap <F6> :%y+<cr>
