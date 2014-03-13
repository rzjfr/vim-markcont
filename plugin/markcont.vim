"TODO:
"#parse markdown file
"#add contetns like https://github.com/thlorenz/doctoc-web
"#make a command to insert the contetns
"#add update contetnt command
"#add remove contetnt command
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
    execute "normal! gg/" . g:markcont_title . "\<cr>"
endfunction

command MarkCont call s:MarkCont()

function! b:MarkUpdate()
    "you should save current buffer before updating content
    call cursor(1, 1)
    if search(g:markcont_title, 'W') == 0
      echo 'It seems there is no Auto generated Content. use :MarkCont to create one.'
    else
      execute "normal! gg/" . g:markcont_title . "\<cr>"
      execute "normal! v/-------------\<cr>njdk"
      call s:MarkCont()
      echo "Contents Updated!"
    endif
endfunction
command MarkUpdate call b:MarkUpdate()

function! b:MarkRemove()
    call cursor(1, 1)
    if search(g:markcont_title, 'W') == 0
      echo 'It seems there is no Auto generated Content. use :MarkCont to create one.'
    else
      execute "normal! gg/" . g:markcont_title . "\<cr>"
      execute "normal! v/-------------\<cr>njdk"
      echo "Contents Removed!"
    endif
endfunction
command MarkRemove call b:MarkRemove()
