" =============================================================================
" Section A: Config {{{1
" Purpose: Config settings for this script.
" =============================================================================

let s:map_arrow_keys = 1
let s:map_alt_keys = 1


" =============================================================================
" Section B: Unmap {{{1
" Purpose: Unmap mappings from Rafi's upstream config
" =============================================================================

" enable search completion in cmd line using up/down
"
if len(mapcheck('<Up>','c')) > 0
	cunmap <Up>
endif
"
if len(mapcheck('<Down>','c')) > 0
	cunmap <Down>
endif


" The plugin rhysd/accelerated-jk moves through display-lines in normal mode,
" these mappings will move through display-lines in visual mode too.
if len(mapcheck('j','v')) > 0
	vunmap j
endif
if len(mapcheck('k','v')) > 0
	vunmap k
endif
if len(mapcheck('<silent>j','n')) > 0
	nunmap <silent> j
endif
if len(mapcheck('<silent>k','n')) > 0
	nunmap <silent> k
endif

" if dein#tap('accelerated-jk')
" 	nmap <silent> j <Plug>(accelerated_jk_gj)
" 	nmap <silent> k <Plug>(accelerated_jk_gk)
" endif


" =============================================================================
" Section C: Mappings {{{1
" Purpose: Custom mappings
" =============================================================================

" Section: Alt-keys {{{2
" -----------------------------------------------------------------------------

" mapping alt keys
" note: is you map <Esc> somwhere this might not work
" if s:map_alt_keys && !has('nvim')
if s:map_alt_keys && !has('nvim')

  " map alt keys
  " --------------
  nmap 3ä <M-ä>
  nmap 3ö <M-ö>
  nmap 3ü <M-ü>
  nmap 3ß <M-ß>
  nmap 3a <M-a>
  nmap 3b <M-b>
  nmap 3c <M-c>
  nmap 3d <M-d>
  nmap 3e <M-e>
  nmap 3f <M-f>
  nmap 3g <M-g>
  nmap 3h <M-h>
  nmap 3i <M-i>
  nmap 3j <M-j>
  nmap 3k <M-k>
  nmap 3l <M-l>
  nmap 3m <M-m>
  nmap 3n <M-n>
  nmap 3o <M-o>
  nmap 3p <M-p>
  nmap 3q <M-q>
  nmap 3r <M-r>
  nmap 3s <M-s>
  nmap 3t <M-t>
  nmap 3u <M-u>
  nmap 3v <M-v>
  nmap 3w <M-w>
  nmap 3x <M-x>
  nmap 3y <M-y>
  nmap 3z <M-z>
  nmap 3- <M-->

endif

if s:map_arrow_keys

nmap OB <Down>
nmap OA <Up>
nmap OD <Left>
nmap OC <Right>

endif

" Section: Remappings for German Keys {{{2
" -----------------------------------------------------------------------------

nmap ö [
nmap ä ]
omap ö [
omap ä ]
xmap ö [
xmap ä ]
imap ö [
imap ä ]


nmap Ö {
nmap Ä }
omap Ö {
omap Ä }
xmap Ö {
xmap Ä }
imap Ö {
imap Ä }

" nmap ß @
nmap ß \


" Section: Navigation {{{2
" -----------------------------------------------------------------------------

nnoremap <Leader>, :<C-u>FZFMru<CR>
nnoremap <Space>1 :<C-u>Defx ~/dev/configs/vim-config-rafi/config<CR>
nnoremap <Space>2 :<C-u>execute('VimwikiIndex 1')<bar>execute('VimwikiGoto Vim/Index')<CR>

" Section: Various {{{2
" -----------------------------------------------------------------------------
nnoremap ,t <C-]>
nnoremap ,o o<Esc>
nnoremap ,O O<Esc>

" escape insert mode via jj
inoremap jj <C-c>
nnoremap ,, <C-^>

" Disable arrow movement, resize splits instead.
nnoremap <silent><Up>  :<C-U>resize +1<CR>
nnoremap <silent><Down>  :<C-U>resize -1<CR>
nnoremap <silent><Left>  :vertical resize +1<CR>
nnoremap <silent><Right> :vertical resize -1<CR>
nnoremap ,dd  :<C-U>call DeleteCurBufferNotCloseWindow()<CR>

nnoremap _t :GoTest<CR>
nnoremap _b :GoBuild<CR>
nnoremap _a :GoAlternate<CR>
" vim: set foldmethod=marker ts=2 sw=2 tw=80 et :
