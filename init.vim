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
Plug 'vim-scripts/DeleteTrailingWhitespace'
Plug 'Lokaltog/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'roman/golden-ratio'
Plug 'fatih/vim-go'
Plug 'Shougo/vimshell.vim'
Plug 'benmills/vimux'
Plug 'troydm/pb.vim'
Plug 'croaker/mustang-vim'
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
Plug 'vim-scripts/ZoomWin' " ZoomWin {{{
map <leader>z <Plug>ZoomWin
" }}}
Plug 'gryf/kickass-syntax-vim'
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline' " AirLine {{{
Plug 'vim-airline/vim-airline-themes'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='powerlineish'
" }}} Plugs definitions

call plug#end()
}}} Configure Plug Manager

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
set t_Co=256
set background=dark
colorscheme hemisu
" }}} Look & feel

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
set relativenumber
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

function! KickRun()
    call VimuxRunCommand('rake start PROGRAM=' . expand('%:t:r'))
endfunction

function! KickDebug()
    call VimuxRunCommand('rake debug PROGRAM=' . expand('%:t:r'))
endfunction

function! KickBasic()
    call VimuxRunCommand('rake start_basic PROGRAM=' . expand('%:t:r'))
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
if has('mouse')
    set mouse=a
    if &term =~ "xterm" || &term =~ "screen"
        autocmd VimEnter *    set ttymouse=xterm2
        autocmd FocusGained * set ttymouse=xterm2
        autocmd BufEnter *    set ttymouse=xterm2
    endif
endif
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
nmap <space> [fzf]
nnoremap [fzf] <nop>

nnoremap <silent> [fzf]f :<C-u>Files<cr>
nnoremap <silent> [fzf]F :<C-u>GFiles<cr>
nnoremap <silent> [fzf]l :<C-u>Lines<cr>
nnoremap <silent> [fzf]L :<C-u>BLines<cr>
nnoremap <silent> [fzf]b :<C-u>Buffers<cr>
nnoremap <silent> [fzf]/ :<C-u>Ag<cr>
nnoremap <silent> [fzf]F :<C-u>GFiles<cr>

nnoremap [fzf]ga :Git add %:p<CR><CR>
nnoremap [fzf]gs :Gstatus<CR>
nnoremap [fzf]gc :Gcommit -v -q<CR>
nnoremap [fzf]gt :Gcommit -v -q %:p<CR>
nnoremap [fzf]gd :Gdiff<CR>
nnoremap [fzf]ge :Gedit<CR>
nnoremap [fzf]gr :Gread<CR>
nnoremap [fzf]gw :Gwrite<CR><CR>
nnoremap [fzf]gl :silent! Glog<CR>:bot copen<CR>
nnoremap [fzf]gp :Ggrep<Space>
nnoremap [fzf]gm :Gmove<Space>
nnoremap [fzf]gb :Git branch<Space>
nnoremap [fzf]go :Git checkout<Space>
nnoremap [fzf]gps :Dispatch! git push<CR>
nnoremap [fzf]gpl :Dispatch! git pull<CR>
nnoremap [fzf]s <C-W><C-W>

nnoremap [fzf]kr :KickRun<cr>
nnoremap [fzf]kd :KickDebug<cr>
nnoremap [fzf]kb :KickBasic<cr>



" Bindings
nno ; :
" Switch to previous buffer
nno <leader><leader> <c-^>
" Jump anywhere
nno <leader>j :call EasyMotion#S(1,1,2)<cr>
" Vertical split
nno <leader>v <C-W>v
" Horizontal split
nno <leader>s <C-W>s
" Cycle over panes
nno <tab> <C-W><C-W>
" Close current pane
nno <leader>x <C-W>c
" Close buffer
nno <leader>X :bd<CR>
" Copy to Clipboard
vno <leader>y :Pbyank<CR>
" Pase from Clipboard
nno <leader>p :Pbpaste<CR>
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
nno <leader>rc :Rc<cr>
" Reload self
nno <leader>rl :Rl<cr>

" save shortuct
nno <leader>w :w<cr>
" quit
nno <leader>q :q<cr>

" Explorer
nno <leader>n :VimFilerExplorer<cr>
" Cheat sheet
nno <leader>c :call CheatSheet()<cr>
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
