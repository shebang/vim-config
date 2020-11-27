" Use this option to enable fmt's experimental mode. This experimental mode is
" superior to the current mode as it fully saves the undo history, so undo/redo
" doesn't break. However, it's slow (creates/deletes a file for every save) and
" it's causing problems on some Vim versions. This has no effect if
" `g:go_fmt_command` is set to `gopls`. By default it's disabled.

" let g:go_fmt_experimental = 1
