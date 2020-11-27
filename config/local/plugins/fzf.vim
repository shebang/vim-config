" ---------------------------------------- "
" fzf
" ---------------------------------------- "
function! s:function(name)
  return function(a:name)
endfunction

let s:bind_opts = 'ctrl-f:page-down,ctrl-b:page-up,shift-left:top,ctrl-space:toggle,shift-right:toggle-preview'
let s:fzf_ignore_files = '"!{.git,node_modules,vendor,tags}/*"'
let s:bat_opts = 'bat --style=numbers --color=always {}'
let $FZF_DEFAULT_OPTS = ''
let $FZF_DEFAULT_OPTS.=" --bind ".s:bind_opts

let s:search_cmd = 'rg --column --line-number --no-heading --color=always --smart-case --'

" use rg --files to search for files
" Print each file that would be searched without actually performing the
" search. This is useful to determine whether a particular file is being searched or not.

let $FZF_DEFAULT_COMMAND = 'rg --files --ignore-case --hidden'
let $FZF_DEFAULT_COMMAND .= ' -g '.s:fzf_ignore_files

" documentation on how to customize
" see: https://github.com/junegunn/fzf.vim
function! s:ripgrep_fzf(...)
  if len(a:000) == 0
    echo 'insufficient arguments'
    return
  endif
  let bang = 0
  let pattern = ''

  let search_path = expand(a:000[0], ':h')
  if len(a:000) == 3
    let pattern = a:000[len(a:000)-2]
    let bang = a:000[len(a:000)-1]
  elseif len(a:000) == 2
    let pattern = ''
    let bang = a:000[len(a:000)-1]
  endif
  let fullscreen = bang
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case  -g '.s:fzf_ignore_files.' -- %s %s || true'
  let initial_command = printf(command_fmt, shellescape(pattern), shellescape(search_path))
  let reload_command = printf(command_fmt, '{q}', shellescape(search_path))
  let spec = {
    \ 'options': [
    \ '--phony',
    \ '--query', pattern,
    \ '--bind', 'change:reload:'.reload_command,
    \ '--prompt', 'Rg> '.shellescape(pathshorten(getcwd())).'/',
    \ '--multi',
    \ '--ansi',
    \ '--bind', 'ctrl-d:page-down,ctrl-u:page-up,shift-left:top,ctrl-space:toggle,shift-right:toggle-preview',
    \ '--bind','alt-a:select-all,alt-d:deselect-all',
    \ '--layout=reverse',
    \ '--info=inline',
    \ ]}

  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), fullscreen)
endfunction

function! s:search_initial_command(initial_cmd, args) abort
  let cmd = a:initial_cmd
  " If 1 or more optional args, first optional arg is introducer...
  let reload_cmd = a:initial_cmd . ' {q} '
  if !empty(a:args.pattern) && !empty(a:args.search_path)
    let suffix = '%s %s || true'
    let path = shellescape(a:args.search_path)
    let init_cmd = printf(cmd . suffix, shellescape(a:args.pattern), path)
    let reload_cmd = a:initial_cmd . ' {q} ' . path
  elseif !empty(a:args.pattern)
    let suffix = '%s || true'
    let init_cmd = printf(cmd . suffix, shellescape(a:args.pattern))
  endif
  return { 'cmd': init_cmd, 'reload_cmd': reload_cmd . ' || true'}

endfunction

" FIXME: should be a formatter func in modules
function! s:get_search_cmd() abort
  if s:search_cmd !~? '^.*\s\+$'
    let s:search_cmd .= ' '
  endif
  return s:search_cmd
endfunction


function! s:cmd_search_in_files(...) abort
  let ret = {}
  if a:0 < 2
    echoerr 'insufficient arguments'
    return
  endif

  " If 1 or more optional args, first optional arg is introducer...
  let ret.pattern =  a:0 >= 2  ?  a:1  :  ''

  if ret.pattern =~ '\m^.*$'
    let pattern = ''
  endif

  " If 2 or more optional args, second optional arg is boxing character...
  let ret.search_path   =  a:0 >= 3  ?  expand(a:2)  :  ''

  let ret.bang = a:000[len(a:000)-1]
  return ret

endfunction

function! s:mrufiles_wrap(...) abort

  function! s:mru_files_for_cwd()
    return map(filter(
      \  systemlist("sed -n '2,$p' ~/.vim_mru_files"),
      \  "v:val =~ '^" . getcwd() . "' && v:val !~ '__Tagbar__\\|\\[YankRing]\\|fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"
      \ ), 'fnamemodify(v:val, ":p:.")')
  endfunction

  let spec = {
    \ 'source':  s:mru_files_for_cwd(),
    \ 'sink':    'edit',
    \ 'options': [
    \ '--prompt', 'MRU> '.shellescape(pathshorten(getcwd())).'/',
    \ '--multi',
    \ '--ansi',
    \ '--bind', 'ctrl-d:page-down,ctrl-u:page-up,shift-left:top,ctrl-space:toggle,shift-right:toggle-preview',
    \ '--bind','alt-a:select-all,alt-d:deselect-all',
    \ '--layout=reverse',
    \ '--info=inline',
    \ '--delimiter', ':',
    \ ],
    \ }

  let spec = fzf#vim#with_preview(spec)

  return spec

endfunction

function! s:ripgrep_wrap(args, ...) abort
  let args = a:args

  let search_cmd = s:get_search_cmd()

  let init_opts = s:search_initial_command(
    \ search_cmd,
    \ a:args)
  let spec = {
    \ 'source': init_opts.cmd,
    \ 'column': 1,
    \ 'sink': 'edit',
    \ 'name':'rg',
    \ 'options': [
    \ '--prompt', 'Rg> '.shellescape(pathshorten(getcwd())).'/',
    \ '--multi',
    \ '--ansi',
    \ '--bind', 'change:reload:'.init_opts.reload_cmd,
    \ '--bind', 'ctrl-d:page-down,ctrl-u:page-up,shift-left:top,ctrl-space:toggle,shift-right:toggle-preview',
    \ '--bind','alt-a:select-all,alt-d:deselect-all',
    \ '--layout=reverse',
    \ '--info=inline',
    \ '--delimiter', ':',
    \ '--nth', '4..',
    \ ]
    \}

  let spec = fzf#vim#with_preview(spec)

  return spec
endfunction

function! s:fzf_wrap(...) abort
  let spec = fzf#wrap(a:1, 0)
  call fzf#run(spec)
endfunction


command! MRUFilesCWD
  \ call <SID>fzf_wrap(<SID>mrufiles_wrap())

command! -nargs=* -complete=dir -bang RipGrep
  \ call <SID>ripgrep_fzf(<f-args>,<bang>0)

command! -bang -nargs=+ -complete=dir Rag
        \ call fzf#vim#ag_raw(<q-args> . ' ',
        \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)"
