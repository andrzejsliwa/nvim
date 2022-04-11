" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" Must have {{{
augroup MyAutoCmd
    autocmd!
augroup END

" prepare path for check
let g:vim_server_path=expand("~/.nvim-andrzej")
" prepare base path for rest of configs

if isdirectory(vim_server_path)
    let $CONFIG_ROOT=g:vim_server_path
    let $MYVIMRC=g:vim_server_path . "/init.vim"
else
    let $CONFIG_ROOT=expand("~/.config/nvim")
endif

command! -bar -nargs=* Rc e $MYVIMRC       " edit init.vim   (this file)
command! -bar -nargs=* Rl :source $MYVIMRC " reload init.vim (this file)
set backspace=indent,eol,start             " enable intuitive backspacing

if &compatible
    set nocompatible  " Be iMproved
endif

" }}} Must have

" Configure Plug manager {{{
call plug#begin()

" Plugs definitions {{{
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" See `man fzf-tmux` for available options
if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif

Plug 'noahfrederick/vim-hemisu'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/DeleteTrailingWhitespace'
Plug 'Lokaltog/vim-easymotion'
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'roman/golden-ratio'
Plug 'fatih/vim-go'
Plug 'Shougo/vimshell.vim'
Plug 'benmills/vimux'
Plug 'wikitopian/hardmode'
Plug 'troydm/pb.vim'
Plug 'croaker/mustang-vim'
Plug 'kassio/neoterm'
let g:neoterm_callbacks = {}
let g:neoterm_autoscroll = 1
function! g:neoterm_callbacks.before_new()
    if winwidth('.') > 100
        let g:neoterm_default_mod = 'botright vertical'
    else
        let g:neoterm_default_mod = 'botright'
    end
endfunction

Plug 'Shougo/neosnippet' " NeoSnippet {{{
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: "\<TAB>"
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
Plug 'Shougo/neosnippet-snippets'
" }}}
Plug 'dhruvasagar/vim-zoom' " vim-zoom {{{
map <leader>z <Plug>(zoom-toggle)
" }}}
Plug 'gryf/kickass-syntax-vim'
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline' " AirLine {{{
Plug 'vim-airline/vim-airline-themes'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1
" }}} Plugs definitions

call plug#end()
" }}} Configure Plug Manager

" Renable syntax highlighting and file types detection {{{
syntax enable
filetype plugin indent on
" }}} Renable syntax highlighting and file types detection

" Look & feel {{{
" Disable the scrollbars (NERDTree)
set guioptions-=r
set guioptions-=L
" Disable the macvim toolbar
set guioptions-=T
set guifont=Anonymous\ Pro:h18

" set term=screen-256color
set background=dark
colorscheme hemisu " gruvbox hemisu
" }}} Look & feel

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" General {{{
" speedup
set ttyfast
set synmaxcol=200
" encoding
set encoding=utf-8
set fileformats=unix
" hide buffers when not displayed
set hidden
set ttimeout
set ttimeoutlen=10
set notimeout
" enable status
set laststatus=2
" enable relative numbering
"   set relativenumber
" configure wrapping
set wrap
set formatoptions+=qrn1
set formatoptions-=o
" configure buffer splits
set splitright
set splitbelow
" display
set display=lastline
set more
" bells
set noerrorbells
set novisualbell
set visualbell t_vb=
set report=2
" scrolling
set scrolloff=3
set sidescrolloff=3
" tabs & indentation
set expandtab
set tabstop=4
set shiftwidth=4
set pastetoggle=<F3>
" }}} General

" Backup & Swap {{{
set nobackup
set nowritebackup
set noswapfile
" }}} Backup & Swap

" Search {{{
set gdefault
set incsearch
set hlsearch
set ignorecase
set smartcase
" }}} Search

" Folding {{{
" don't fold by default
set nofoldenable
" }}}

" Snippets {{{
let snippets_dir = $CONFIG_ROOT . "/snippets"
" }}} Snippets

" Custom functions {{{

" Strip trainling whitespaces {{{
function! <SID>StripTrailingWhitespaces()
    " Preparation: "ave last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up:
    " restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }}} Strip trainling whitespaces

" Line number toggle {{{
function! LineNumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set nonumber
        set relativenumber
    endif
endfunc
" }}} Line number toggle

" IndentErlangWithEmacs() {{{
let s:emacs_indenter = expand('~/.vim/emacs_indent.sh')
function! IndentErlangWithEmacs()
    execute 'silent :w'
    execute 'silent !' . s:emacs_indenter . ' ' . expand('%:p')
    execute 'silent :e'
    redraw!
endfunction
" }}}

function! RunCommand(command)
    if exists('$TMUX')
        call VimuxRunCommand(a:command)
    else
        execute ':T ' . a:command
    end
endfunction

function! KickRun()
    execute 'w'
    let c='rake start PROGRAM=' . expand('%:t:r')
    call RunCommand(c)
endfunction

function! KickDebug()
    execute 'w'
    let c='rake debug PROGRAM=' . expand('%:t:r')
    call RunCommand(c)
endfunction

function! KickBasic()
    execute 'w'
    let c='rake start_basic PROGRAM=' . expand('%:t:r')
    call RunCommand(c)
endfunction


" open cheat sheet {{{
function! CheatSheet()
    sp | e $CONFIG_ROOT/cheatsheet
endfunction
" }}} open cheat sheet

" Edit snippet {{{
function! EditMySnippets()
    execute "sp | e " . $CONFIG_ROOT . "/snippets/" . &ft . ".snippets"
endfunction

function! ReloadMySnippets()
    execute "w"
    execute "bd"
    execute "call ReloadAllSnippets()"
endfunction
" }}} Edit snippet

" }}} Custom functions

" Commands defs {{{
command! -bar -nargs=* KickRun call KickRun()
command! -bar -nargs=* KickDebug call KickDebug()
command! -bar -nargs=* KickBasic call KickBasic()
command! -bar -nargs=* Cheat call CheatSheet()
command! -bar -nargs=* EditMySnippets call EditMySnippets()
command! -bar -nargs=* ReloadMySnippets call ReloadMySnippets()
command! -bar -nargs=* LineNumberToggle call LineNumberToggle()
command! IndentErl call IndentErlangWithEmacs()
" }}} Commands defs

" Auto commands {{{
"autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup FileTypes
    au!
    au FileType ruby    setlocal shiftwidth=2 tabstop=2
    au FileType snippet setlocal shiftwidth=4 tabstop=4
    au FileType kickass setlocal shiftwidth=4 tabstop=4
    au FileType make    setlocal noexpandtab shiftwidth=4 tabstop=4
    au FileType snippet setlocal expandtab shiftwidth=4 tabstop=4
    au BufNewFile,BufRead *.asm set filetype=kickass
    au BufNewFile,BufRead *.s set filetype=kickass
augroup END

augroup Fugitive
    au!
    " Cleanup fugitive buffer
    au BufReadPost fugitive://* set bufhidden=delete
    au BufReadPost fugitive://*
                \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
                \   nnoremap <buffer> .. :edit %:h<CR> |
                \ endif
augroup END

augroup Other
    au!
    au BufWritePre * :call <SID>StripTrailingWhitespaces()
    " au BufWinEnter * let w:m2=matchadd('ToLong', '\%>80v.\+', -1)
augroup END
" }}} Auto commands

" Handle mouse {{{
"if has('mouse')
set mouse=a
"    if &term =~ "xterm" || &term =~ "screen"
"        autocmd VimEnter *    set ttymouse=xterm2
"        autocmd FocusGained * set ttymouse=xterm2
"        autocmd BufEnter *    set ttymouse=xterm2
"    endif
"endif
" }}}

" Handle cursor shape {{{
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}


" Bindings {{{
nmap <space> [space]
nnoremap [space] <nop>

nnoremap <silent> [space]f :<C-u>Files<cr>
nnoremap <silent> [space]F :<C-u>GFiles<cr>
nnoremap <silent> [space]l :<C-u>Lines<cr>
nnoremap <silent> [space]L :<C-u>BLines<cr>
nnoremap <silent> [space]b :<C-u>Buffers<cr>
nnoremap <silent> [space]/ :<C-u>Ag<cr>

nnoremap [space]e :Explore<CR>
nnoremap [space]E :Vexplore<CR>
noremap [space]s <C-W><C-W>

nnoremap [space]kr :KickRun<cr>
nnoremap [space]kd :KickDebug<cr>
nnoremap [space]kb :KickBasic<cr>

" standar gt & gT
nno [space]tn :tabnew<cr>
nno [space]tt :tabnext
nno [space]tm :tabmove
nno [space]tc :tabclose<cr>
nno [space]to :tabonlt<cr>
" Bindings
nno ; :
" Switch to previous buffer
nno <space><space> <c-^>
" Jump anywhere
nno [space]j :call EasyMotion#S(1,1,2)<cr>
" Vertical split
nno [space]v <C-W>v
" Horizontal split
nno [space]s <C-W>s
" Cycle over panes
nno <tab> <C-W><C-W>
" Close current pane
nno [space]x <C-W>c
" Close buffer
nno [space]X :bd<CR>
" Copy to Clipboard
vno [space]y :Pbyank<CR>
" Pase from Clipboard
nno [space]p :Pbpaste<CR>
" Reset search
nno <CR> :nohlsearch<CR><CR>
" Reformat code
nno <leader>f gg=G``
" Toggle fullscreen
nno <leader>F :set invfu<CR>

" reload snippets for current filetype
nno <leader>sr :ReloadMySnippets<cr>
" edit snippets for current filetype
nno <leader>se :EditMySnippets<cr>
" vimux & rebar
map <leader>tp :VimuxPromptCommand<cr>
map <leader>t  :VimuxRunLastCommand<cr>

" Edit self
nno [space]rc :Rc<cr>
" Reload self
nno [space]rl :Rl<cr>

" save shortuct
nno [space]w :w<cr>
" quit
nno [space]q :q<cr>

" Explorer
" Cheat sheet
nno [space]c :call CheatSheet()<cr>
" Move line left
nno < <<
nmap < <<
" Move line right
nno > >>
nmap > >>
" Move selection left
vmap < <gv
" Move selection right
vmap > >gv
" Better search
nno / /\V
vno / /\V

" }}} Bindings
