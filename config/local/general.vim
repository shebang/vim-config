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


