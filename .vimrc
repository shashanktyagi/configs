
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
Plug 'levelone/tequila-sunrise.vim' 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'bronson/vim-trailing-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'fisadev/vim-isort'
Plug 'Vimjas/vim-python-pep8-indent'
" All of your Plugins must be added before the following line
call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype on
filetype plugin on
filetype indent on
let mapleader = ","
let g:mapleader = ","

" Plugins settings:

" fzf
nnoremap <silent> <C-p> :Files<cr>
nnoremap <silent> <leader>ls :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent> <leader>gs :GFiles?<cr>
nnoremap <silent> <leader>gl :Commits<cr>
nnoremap <silent> <leader>gf :BCommits<cr>
nnoremap <silent> <leader>ag :Ag<cr>
vnoremap <silent> <leader>ag :call SearchVisualSelectionWithAg()<CR>
function! SearchVisualSelectionWithAg() range
   let old_reg = getreg('"')
   let old_regtype = getregtype('"')
   let old_clipboard = &clipboard
   set clipboard&
   normal! ""gvy
   let selection = getreg('"')
   call setreg('"', old_reg, old_regtype)
   let &clipboard = old_clipboard
   execute 'Ag' selection
endfunction


let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

" fugitive
nnoremap <silent> <leader>gd :Gvdiff<cr>

" coc.nvim
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
nmap <silent> <leader>jd <Plug>(coc-definition)
nmap <silent> <leader>jr <Plug>(coc-references)
nmap <silent> <leader>ji <Plug>(coc-implementation)

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type


let python_highlight_all = 1

let g:airline_theme='jellybeans'
set background=dark
colorscheme tequila-sunrise

" air-line
let g:airline_powerline_fonts = 1
"
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ' '
let g:airline_right_sep = ' '
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


let g:airline#extensions#tabline#enabled = 1

map <C-n> :NERDTreeToggle<CR>
let g:NERDCompactSexyComs = 1
let g:NERDSpaceDelims = 1
let NERDDefaultAlign="left"

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

set statusline^=%{coc#status()}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt+=vertical

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

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

map <leader>p :setlocal paste!<cr>
nnoremap <leader>w :w<cr>

nnoremap <leader>b oimport ipdb; ipdb.set_trace()<Esc>

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

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

" open file with cursor at previous location
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
