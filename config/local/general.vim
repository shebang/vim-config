set mouse=v                  " Disable mouse in command-line and normal mode
set novisualbell             " Use no visual bell at all
set relativenumber					 " enable relative numbers

" Rafi's fix for copy/paste works for me: https://github.com/rafi/vim-config/issues/128
set clipboard& clipboard^=unnamed,unnamedplus

if has('nvim-0.4')
	set signcolumn=auto:1
elseif exists('&signcolumn')
	set signcolumn=yes
endif


" Pseudo-transparency for completion menu and floating windows
if has('termguicolors') && &termguicolors
	if exists('&pumblend')
		set pumblend=0
	endif
	if exists('&winblend')
		set winblend=0
	endif
endif

