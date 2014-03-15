"TODO:
"#parse markdown file
"#add contetns like https://github.com/thlorenz/doctoc-web
"#make a command to insert the contetns
"#add update contetnt command
"#add remove contetnt command
"#add goto for content list
"#set header level
"support Setext-style headers in contents
"user should choose 'contents' header type

"Note: I reserved level 1 indentation for setext-style headers and it seems that
"i'm not going to add that functionality soon. so i just changed defaults for now"

" defining the path of the plugin
let s:plugin_path = escape(expand('<sfile>:p:h'), '\')

"check for user defined values
if ! exists('markcont_title')
  let g:markcont_title = ' Contents'
endif

if ! exists('markcont_tab')
  let g:markcont_tab = '4'
endif
" max shuld be 6
if ! exists('markcont_level')
  let g:markcont_level = '2'
endif

function s:MarkCont()
    execute "normal! mc"
    let s:file_path = expand("%:p")
    execute ':r !python2 ' . s:plugin_path . '/markcont.py ' . s:file_path . ' "' . g:markcont_title . '" ' . g:markcont_tab . " " . g:markcont_level
    execute "normal! gg/" . g:markcont_title . "\<cr>"
endfunction

command MarkCont call s:MarkCont()

function! b:MarkUpdate()
    call cursor(1, 1)
    normal 0zR
    if search(g:markcont_title, 'W') == 0
      echo 'It seems there is no Auto generated Content. use :MarkCont to create one.'
    else
      execute 'silent update'
      call b:MarkRemove()
      call s:MarkCont()
      echo "Contents Updated!"
    endif
endfunction
command MarkUpdate call b:MarkUpdate()

function! b:MarkRemove()
    call cursor(1, 1)
    normal 0zR
    if search(g:markcont_title, 'W') == 0
      echo 'It seems there is no Auto generated Content. use :MarkCont to create one.'
    else
      execute "normal! gg/" . g:markcont_title . "\<cr>"
      execute "normal! v/-------------\<cr>n$dk"
    endif
endfunction
command MarkRemove call b:MarkRemove()

let s:list_regex='\v([ ]*)- \[(.+)\]\(#.+\)'

function! b:MarkGoto()
    normal 0zR
    if search(s:list_regex, 'Wc', line(".")) == 0
      echo 'It seems that you are not in Content list'
    else
      let l:regback=(@")
      execute "normal! 0v" . '"by'
      if (@b) == "-"
        let l:level=1
      else
        execute "normal! 0v/-\<cr>h" . '"by'
        if len(@b) < g:markcont_tab || (@b) !~ '^[ ]\+$'
          echo "I think indentation is wrong. see g:markcont_tab for setting tab value."
          return
        endif
        let l:level=(len(@b)/g:markcont_tab) + 1
      endif
      execute "normal! f[vi[" . '"by'
      let l:key=(@b)
      try
        execute "normal! /^#" . '\{' . l:level . '}\%[ ]' . l:key . "\<cr>"
        let @"=l:regback
      catch /E486:/
        echo 'It seems you do not have that heading anymore. try :MarkUpdate'
      endtry
    endif
endfunction
command MarkGoto call b:MarkGoto()

function! MarkEnterMap()
  "noremap <expr> <Enter> MarkEnterMapMap()"
  if search(s:list_regex, 'Wc', line(".")) == 0
    return ''
  else
    return ':MarkGoto'
  endif
endfunction
