
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
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'fisadev/vim-isort'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
Plug 'jiangmiao/auto-pairs'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tomtom/tcomment_vim'
Plug 'b4winckler/vim-objc'
Plug 'junegunn/vim-easy-align'
" All of your Plugins must be added before the following line
call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype on
filetype plugin on
filetype indent on
let mapleader = " "

" Plugins settings:

" fzf
" fzf file fuzzy search that respects .gitignore
" " If in git directory, show only files that are committed, staged, or unstaged else use regular :Files
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
nnoremap <silent> <leader>m :Buffers<cr>
nnoremap <silent> <leader>ls :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gv :Gvdiffsplit!<cr>
nnoremap <silent> <leader>gl :Commits<cr>
nnoremap <silent> <leader>gf :BCommits<cr>
nnoremap <silent> <leader>ag :Ag<cr>
vnoremap <silent> <leader>ag :call SearchVisualSelectionWithAg()<CR>
nnoremap <silent> <leader>bs :Lines<cr>
nnoremap <silent> <leader>bl :BLines<cr>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

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

function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction


let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'


" coc.nvim
" use <tab> for trigger completion and navigate to next complete item

let g:coc_global_extensions = [
    \ 'coc-python',
    \ 'coc-json',
    \ 'coc-clangd',
    \ 'coc-cmake',
    \ 'coc-go'
    \ ]

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

nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gx :CocCommand clangd.switchSourceHeader<cr>

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
nnoremap <leader>rn <Plug>(coc-rename)

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type


let python_highlight_all = 1

let g:airline_theme='gruvbox'
set background=dark
colorscheme gruvbox

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

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

set statusline^=%{coc#status()}
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = {
  \ '\': {
  \     'pattern': '\\$',
  \ },
  \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &diff
    set diffopt-=internal
    set diffopt+=vertical
endif

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

set autoindent
set shiftwidth=4
set tabstop=4

if has("autocmd")
    " 1 tab == 4 spaces
    au FileType python setlocal shiftwidth=4 tabstop=4
    au FileType go setlocal shiftwidth=4 tabstop=4
    au FileType c setlocal shiftwidth=2 tabstop=2 cindent
    au FileType cuda setlocal shiftwidth=2 tabstop=2 cindent
    au FileType cpp setlocal shiftwidth=2 tabstop=2 cindent
    au FileType objcpp setlocal shiftwidth=2 tabstop=2 cindent
    au FileType cmake setlocal shiftwidth=2 tabstop=2 cindent
    au FileType sh setlocal shiftwidth=4 tabstop=4
    au BufNewFile,BufRead *.metal set syntax=cpp
endif

set cursorline

set cc=80

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
nnoremap <leader>s *``
nnoremap <leader>t :terminal<cr>

vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

nnoremap <silent> <cr> :noh<cr><esc>

nnoremap <C-e> <C-e><C-e>
nnoremap <C-y> <C-y><C-y>

" indent code
vnoremap < <gv
vnoremap > >gv
nnoremap gp '[v']
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" zoom vim pane
noremap <leader>z <c-w>_ \| <c-w>\|
noremap <leader>zz <c-w>=
noremap <leader>d <c-w>q

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

" open file with cursor at previous location
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
