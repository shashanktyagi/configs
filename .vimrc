"":Ai:Aiplug (https://github.com/junegunn/vim-plug) settings
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
Plug 'christoomey/vim-tmux-navigator'
Plug 'bronson/vim-trailing-whitespace'
Plug 'kien/ctrlp.vim'
Plug 'hdima/python-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'jlanzarotta/bufexplorer'
Plug 'scrooloose/syntastic'
Plug 'whatyouhide/vim-gotham'

" All of your Plugins must be added before the following line
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins settings:

let g:ctrlp_working_path_mode = 0
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

let python_highlight_all = 1

let g:airline_theme='base16_embers'

let g:airline#extensions#tabline#enabled = 1



map <C-n> :NERDTreeToggle<CR>

let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>

let g:syntastic_python_checkers=['pyflakes']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Enable filetype plugins
filetype on
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

nnoremap <leader>p oimport ipdb;ipdb.set_trace()<Esc>

map <leader>pp :setlocal paste!<cr>


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

"Run macro in resgiter q"
map <leader><leader> @q

noremap <leader>w :w<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enter to insert new empty line after current line
nnoremap <cr> o<esc>k



set autoread

" indent code
vnoremap < <gv
vnoremap > >gv


set nobackup
set nowb
set noswapfile

set laststatus=2

set t_Co=256
syntax on
colorscheme gotham

set encoding=utf8

" Sets how many lines of history VIM has to remember
set history=500

" remove highlight
nnoremap <silent> <esc> :noh<cr><esc>

" Marker for change, replace etc.
set cpoptions+=$

" set relative numbers and current line number
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


set noshowmode


" move view pane 10 lines at a time
noremap <C-e> 10<C-e>
noremap <C-y> 10<C-y>

" auto-complete braces and quotes
inoremap ( ()<Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i

set colorcolumn=80

