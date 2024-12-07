scriptencoding utf-8

runtime ftplugin/changelog.vim

let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_matchparen        = 1

set number
set tabstop=2
set backspace=indent,eol,start
set showmatch
set matchtime=3
set switchbuf=useopen
set laststatus=2
set linespace=4
set shiftwidth=2
set expandtab
set updatetime=500
set ruler
" Command-line completion.
setglobal wildmenu wildmode=list:longest,full wildignorecase
set backspace=indent,eol,start
set breakindent
set ttyfast
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set mouse=a
set nocompatible
set showcmd " 入力中のコマンドを表示
set showfulltag 
setglobal infercase
set hlsearch
filetype plugin indent on
set hidden
au CursorHold * checktime  
syntax on
set history=5000
set ignorecase
set smartcase
set wrapscan
set wrap
set incsearch
set visualbell t_vb=
set noundofile
set gdefault " 置換の時 g オプションをデフォルトで有効にする
set ttimeoutlen=10
set nocursorcolumn
set cursorline
set norelativenumber
set breakindentopt=shift:0
set helplang=ja,en
set synmaxcol=1500
syntax sync minlines=1500
set synmaxcol=256
set concealcursor=nc
set conceallevel=2
set diffopt=vertical,internal,filler,algorithm:histogram,indent-heuristic
set autowriteall
set backup
set modifiable
set write
set writebackup
set noswapfile
set display=lastline
set listchars=eol:¬,tab:▸\
set cmdheight=1
set iminsert=0
set imsearch=-1
set showcmd               " show command on statusline
" set lazyredraw "マクロなどの途中経過を描写しない
set report=0              " report any changes
set display=lastline      " display last line in a window AMAP
set wildoptions+=pum
set splitkeep=screen
set scrolloff=5 " 5行余裕を持ってスクロール
set splitbelow            " 新しく開くときに下に開く
set splitright            " 新しく開くときに右に開く
set formatoptions=q
set fileformats=unix,dos,mac
set autoread
set signcolumn=yes
set re=0
set rdt=0

let &grepprg='rg --vimgrep'

function! SetCustomCellWidths()
  call setcellwidths([
    \ [ 0x2500, 0x257f, 1 ],
    \ [ 0x2100, 0x214d, 2 ],
    \ [ 0x26A0, 0x26A0, 2 ],
    \ [ 0x2014, 0x2014, 2 ],
    \ [ 0x2191, 0x2191, 1 ],
    \ [ 0x2026, 0x2026, 2 ],
    \ [ 0x2192, 0x2192, 2 ],
    \ [ 0x2713, 0x2713, 1 ],
    \ [ 0x203B, 0x203B, 2 ],
    \ [ 0x2935, 0x2935, 2 ],
    \ [ 0x2459, 0x2469, 2 ],
    \ [ 0x2606, 0x2606, 2 ],
    \ ])
endfunction

augroup CustomCellWidths
  autocmd!
  autocmd BufLeave changelog,markdown,text call SetCustomCellWidths()
augroup END



if g:IsMacGvim()
  set backupdir=$HOME/Dropbox/files/time_backup
	" IME 制御（gvim用）
	set macmeta
	set iminsert=0
	set imsearch=-1
  set clipboard=unnamed
endif

if g:IsMacNeovim() || !g:IsMacNeovimInWork()
  set backupdir=$HOME/Dropbox/files/time_backup
  set clipboard=unnamed
  set ambiwidth=single
endif

if g:IsMacNeovimInWork()
  set backupdir=$HOME/time_backup
  set clipboard=unnamed
  set ambiwidth=single
endif

if g:IsWindowsGvim()
	" IME 制御（gvim用）
	set iminsert=0
	set imsearch=-1
  set backupdir=g:/dropbox/files/time_backup
	set undodir=g:/dropbox/files/time_backup
  set clipboard=unnamed
endif

if g:IsWindowsNeovim()
endif

if g:IsLinux()
  set backupdir=/home/kf/time_backup
  set clipboard&
  set clipboard^=unnamedplus
endif

if g:IsWsl()
  set backupdir=$HOME/time_backup
  set clipboard&
  set clipboard^=unnamedplus
  let g:clipboard = {
       \   'name': 'myClipboard',
       \   'copy': {
       \      '+': 'win32yank.exe -i',
       \      '*': 'win32yank.exe -i',
       \    },
       \   'paste': {
       \      '+': 'win32yank.exe -o',
       \      '*': 'win32yank.exe -o',
       \   },
       \   'cache_enabled': 1,
       \ }
endif

" time backup {{{1
set backupskip=/tmp/*,/private/tmp/*
augroup time_backup
  if strftime('%M') >= 0 && strftime('%M') < 10
    au BufWritePre * let &bex = '.' . strftime('%Y%m%d_%H') . '00'
  endif
  if strftime('%M') >= 10 && strftime('%M') < 20
    au BufWritePre * let &bex = '.' . strftime('%Y%m%d_%H') . '10'
  endif
  if strftime('%M') >= 20 && strftime('%M') < 30
    au BufWritePre * let &bex = '.' . strftime('%Y%m%d_%H') . '20'
  endif
  if strftime('%M') >= 30 && strftime('%M') < 40
    au BufWritePre * let &bex = '.' . strftime('%Y%m%d_%H') . '30'
  endif
  if strftime('%M') >= 40 && strftime('%M') < 50
    au BufWritePre * let &bex = '.' . strftime('%Y%m%d_%H') . '40'
  endif
  if strftime('%M') >= 50 && strftime('%M') < 59
    au BufWritePre * let &bex = '.' . strftime('%Y%m%d_%H') . '50'
  endif
augroup END
" }}}1
