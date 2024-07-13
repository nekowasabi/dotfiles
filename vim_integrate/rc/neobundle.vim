" neobundle
let g:neobundle_default_git_protocol='https'
if has('vim_starting')
		if &compatible
				set nocompatible               " Be iMproved
		endif

		" Required:
		set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" originalrepos on github
" NeoBundle 'tomtom/tcomment_vim'
" NeoBundle 'AmaiSaeta/closesomewindow.vim'
" NeoBundle 'altercation/vim-colors-solarized'
" NeoBundle 'Shougo/neocomplete.vim'
" NeoBundle 'Shougo/neoinclude.vim'
" NeoBundle 'Shougo/neco-syntax'
" NeoBundle 'ujihisa/neco-look'
" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'Shougo/neomru.vim'
" NeoBundle 'Shougo/vimfiler.vim'
" NeoBundle 'Shougo/neosnippet.vim'
" NeoBundle 'Shougo/neosnippet-snippets'
" NeoBundle 'Shougo/unite-outline'
" NeoBundle 'Lokaltog/vim-easymotion'
" NeoBundle 'fuenor/JpFormat.vim'
" NeoBundle 'rhysd/clever-f.vim'
" NeoBundle 'sakuraiyuta/commentout.vim'
" NeoBundle 'kana/vim-textobj-user'
" NeoBundle 'kana/vim-textobj-jabraces'
" NeoBundle 'osyo-manga/vim-textobj-multiblock'
" NeoBundle 'osyo-manga/vim-textobj-multitextobj'
" NeoBundle 'vim-scripts/vim-auto-save'
" NeoBundle 'tyru/restart.vim'
" NeoBundle 'osyo-manga/vim-vigemo'
" NeoBundle 'haya14busa/vim-migemo'
NeoBundle 'Shougo/vimproc.vim', {
						\ 'build' : {
						\     'windows' : 'tools\\update-dll-mingw',
						\     'cygwin' : 'make -f make_cygwin.mak',
						\     'mac' : 'make -f make_mac.mak',
						\     'linux' : 'make',
						\     'unix' : 'gmake',
						\    },
						\ }
" NeoBundle 'osyo-manga/vim-hopping'
" NeoBundle 'LeafCage/yankround.vim'
" NeoBundle 'ujihisa/shadow.vim'
" NeoBundle 'thinca/vim-unite-history'
" NeoBundle 'kana/vim-textobj-user'
" NeoBundle 'kana/vim-textobj-indent'
" NeoBundle 'LeafCage/foldCC.vim'
" NeoBundle 'thinca/vim-partedit'
" NeoBundle 'deton/jasegment.vim'
" NeoBundle 'tpope/vim-surround'
" NeoBundle 'kana/vim-textobj-fold'
" NeoBundle 'tacroe/unite-mark'
" NeoBundle 'plasticboy/vim-markdown'
" NeoBundle 'BimbaLaszlo/vim-eightheader'
" NeoBundle 'osyo-manga/unite-fold'
" NeoBundle 'schickling/vim-bufonly'
" NeoBundle 'osyo-manga/vim-textobj-multiblock'
" NeoBundle 'osyo-manga/vim-textobj-multitextobj'
" NeoBundle 'terryma/vim-expand-region'
" NeoBundle 'haya14busa/incsearch.vim'
" NeoBundle 'haya14busa/incsearch-fuzzy.vim'
" NeoBundle 'haya14busa/incsearch-fuzzy.vim'
" NeoBundle 'haya14busa/incsearch-migemo.vim'
" NeoBundle 'haya14busa/incsearch-easymotion.vim'
" NeoBundle 'tyru/qfhist.vim'
" NeoBundleLazy 'Shougo/unite-help'
" NeoBundle 'rhysd/unite-codic.vim'
" NeoBundle 'koron/codic-vim'
" NeoBundle 'tyru/open-browser.vim'
" NeoBundle 'termoshtt/toggl.vim'
" NeoBundle 'vim-jp/vital.vim'
" NeoBundle 'AndrewRadev/switch.vim'
" NeoBundle 'fuenor/im_control.vim'
" NeoBundle 'basyura/TweetVim'
" NeoBundle 'basyura/twibill.vim'
" NeoBundle 'mattn/webapi-vim'
" NeoBundle 'basyura/bitly.vim'
" NeoBundle 'mattn/favstar-vim'
" NeoBundle 'tsukkee/lingr-vim'
" NeoBundle 'tpope/vim-obsession'
" NeoBundle 'itchyny/lightline.vim'
" NeoBundle 'kana/vim-smartchr'
" NeoBundleLazy 'marijnh/tern_for_vim'
" NeoBundle 'vim-scripts/utl.vim'
" NeoBundle 'Shougo/vimshell.vim'
" NeoBundle 'nathanaelkane/vim-indent-guides'
" NeoBundle 't9md/vim-choosewin'
" NeoBundle 'kana/vim-smartinput'
" NeoBundle 'thinca/vim-quickrun'
" " NeoBundle 'osyo-manga/vim-watchdogs'
" NeoBundle 'osyo-manga/shabadou.vim'
" NeoBundle 'scrooloose/syntastic'
" " NeoBundle 'haya14busa/vim-signjk-motion'
" NeoBundle 'junegunn/gv.vim'
" NeoBundle 'tpope/vim-fugitive'
" NeoBundle 'itchyny/calendar.vim'
" " NeoBundle 'Shougo/neopairs.vim'
" NeoBundle 'shawncplus/aaacomplete.vim'
" NeoBundle 'gcmt/wildfire.vim'
" NeoBundle 'sorah/unite-ghq'
" NeoBundle "vim-scripts/taglist.vim"
" NeoBundle "junegunn/vim-easy-align"
" NeoBundle "StanAngeloff/aaa.vim"
" " Macのみブラウザをリロード
" NeoBundle 'tell-k/vim-browsereload-mac'
" NeoBundle 'malithsen/trello-vim'
" NeoBundle 'termoshtt/curl.vim'
" NeoBundle 'vim-scripts/RTM.vim'

if neobundle#tap('tern_for_vim')
  call neobundle#config({
  \   'build': {
  \     'others': 'npm install'
  \   },
  \   'autoload': {
  \     'functions': ['tern#Complete', 'tern#Enable'],
  \     'filetypes': ['javascript']
  \   },
  \   'commands': [
  \     'TernDef', 'TernDoc', 'TernType', 'TernRefs', 'TernRename'
  \   ]
  \ })

  let g:tern_map_keys = 0

  call neobundle#untap()
endif

call neobundle#end()


filetype plugin indent on     " required!
filetype indent on

NeoBundleCheck
