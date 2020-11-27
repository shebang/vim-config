function! s:source_file(path, ...)
  " Source user configuration files with set/global sensitivity
  let use_global = get(a:000, 0, ! has('vim_starting'))
  let abspath = resolve($VIM_PATH . '/' . a:path)
  if ! use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  let tempfile = tempname()
  let content = map(readfile(abspath),
    \ "substitute(v:val, '^\\W*\\zsset\\ze\\W', 'setglobal', '')")
  try
    call writefile(content, tempfile)
    execute printf('source %s', fnameescape(tempfile))
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction

" let g:lvconf_go_test_args='-v -count=1 -race -timeout 5000s'

call s:source_file('config/local/filetype.vim')

call s:source_file('config/local/general.vim')
call s:source_file('config/local/buffers.vim')
call s:source_file('config/local/mappings.vim')
call s:source_file('config/local/plugins/fzf.vim')
call s:source_file('config/local/plugins/vim-go.vim')

