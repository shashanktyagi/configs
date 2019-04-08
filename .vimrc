
" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Autoload vimrc on change

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

call plug#begin('~/.vim/plugged')
Plug 'Valloric/YouCompleteMe' " Requires compilation
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'kien/ctrlp.vim'
Plug 'hdima/python-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
Plug 'bronson/vim-trailing-whitespace'
Plug 'morhetz/gruvbox'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'fisadev/vim-isort'
Plug 'ludovicchabant/vim-gutentags'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'"
" All of your Plugins must be added before the following line
call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins settings:

let g:ctrlp_working_path_mode = 'cr'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_regexp = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

let python_highlight_all = 1

let g:airline_theme='gruvbox'
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'

" air-line
let g:airline_powerline_fonts = 1
"
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


let g:airline#extensions#tabline#enabled = 1

map <C-n> :NERDTreeToggle<CR>

let g:syntastic_python_checkers=['flake8']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_global_ycm_extra_conf = "~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"

let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

let g:NERDCompactSexyComs = 1
let g:NERDSpaceDelims = 1
let NERDDefaultAlign="left"

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

set statusline+=%{gutentags#statusline()}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt+=vertical

filetype on
filetype plugin on
filetype indent on
set nocompatible

" solve delays in O
set timeout timeoutlen=3000 ttimeoutlen=100

set splitright

set nobackup
set nowb
set noswapfile

set laststatus=2
" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

syntax on

set encoding=utf8

" Sets how many lines of history VIM has to remember
set history=500


" Enable filetype plugins

" Set to auto read when a file is changed from the outside
set autoread
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","


" Marker for change, replace etc.
set cpoptions+=$
syntax on
set relativenumber
set number
set numberwidth=3

" Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
"set smartindent

set cursorline

set cc=100

set noshowmode

set noerrorbells

set novisualbell

set t_vb=

set tm=500

set scrolloff=10


"close the current buffer
map <leader>bd :bd<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>m :tabnext<cr>
map <leader>n :tabprevious<cr>

map <leader>p :setlocal paste!<cr>
nnoremap <leader>w :w<cr>

nnoremap <leader>b oimport ipdb; ipdb.set_trace()<Esc>
nnoremap <leader>gd :YcmCompleter GetDoc<cr>
nnoremap <leader>] :YcmCompleter GoTo<cr>

nnoremap <silent> <cr> :noh<cr><esc>

nnoremap <C-e> <C-e><C-e>
nnoremap <C-y> <C-y><C-y>

" indent code
vnoremap < <gv
vnoremap > >gv
nnoremap gp '[v']


" resize  panes quickly
nnoremap <silent> <leader>= 10<C-w>+
nnoremap <silent> <leader>- 10<C-w>-
