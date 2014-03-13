"TODO:
"#parse markdown file
"#add contetns like https://github.com/thlorenz/doctoc-web
"#make a command to insert the contetns
"add update contetnt command
"support Setext-style headers in contents
"user should choose 'contents' header type


" defining the path of the plugin
" :p modifier makes the pathname absolute
" :h suffix drops the last pathname component
let g:plugin_path = escape(expand('<sfile>:p:h'), '\')

" get the current edited file
" % says the current file and
let g:current_file = fnamemodify("%", ":p")

if ! exists('markcont_title')
  let g:markcont_title = 'Contents'
endif

if ! exists('markcont_tab')
  let g:markcont_tab = '4'
endif

function! s:MarkCont()
    execute ':r !python ' . g:plugin_path . '/markcont.py ' . g:current_file . ' "' . g:markcont_title . '" ' . g:markcont_tab
endfunction

command MarkCont call s:MarkCont()
