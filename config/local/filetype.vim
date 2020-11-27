" File Types
" ===
let s:go_tab_indent_fg='#373b41'
let s:go_tab_indent_bg='#262626'

function! GoRunWrapper() abort
  if exists('g:lvconf_go_run_args')
    execute 'GoRun '.g:lvconf_go_run_args
  else
    execute 'GoRun'
  endif
endfunction

function! GoTestWrapper() abort
  if exists('g:lvconf_go_test_args')
    execute 'GoTest '.g:lvconf_go_test_args
  else
    execute 'GoTest'
  endif
endfunction


function! s:FiletypeGoMappings() abort
  nmap <buffer><M-p> :<C-U>GoLint<CR>
  nmap <buffer><M-t> :<C-U>call GoTestWrapper()<CR>
  nmap <buffer><M-u> :<C-U>GoAlternate<CR>
  nmap <buffer><M-b> :<C-U>GoBuild<CR>
  nmap <buffer><M-r> :<C-U>call GoRunWrapper()<CR>
endfunction

augroup vimrc_ft_go " {{{

  autocmd!
  autocmd FileType go
    \ if !has('gui_running')
    \ | setlocal listchars=tab:\┃\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
    \ | execute 'highlight SpecialKey guifg=' . s:go_tab_indent_fg . ' guibg=' . s:go_tab_indent_bg
    \ | endif | call s:FiletypeGoMappings()

  " Run gofmt on save
  " autocmd BufWritePre *.go !gofmt -w %

augroup END " }}}

augroup vimrc_ft_folds

  autocmd TextChangedI,TextChanged *
        \ if &l:foldenable && &l:foldmethod !=# 'manual' |
        \   let b:foldmethod_save = &l:foldmethod |
        \   let &l:foldmethod = 'manual' |
        \ endif

  autocmd BufWritePost *
        \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
        \   let &l:foldmethod = b:foldmethod_save |
        \   execute 'normal! zx' |
        \ endif

  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview
augroup END



" vim: set foldmethod=marker ts=2 sw=2 tw=80 et :
